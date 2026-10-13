import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:odo24_mobile/core/app_exception.dart';

enum ContentType { json, string }

final class ResponseData {
  final ContentType contentType;
  final Object? body;

  const ResponseData({required this.contentType, required this.body});
}

class ResponseHandler {
  static Future<Map<String, Object?>?> parseJSON(Future<Response> api) async {
    final result = await _parse(api);
    if (result == null) {
      return null;
    }
    if (result.contentType == ContentType.json) {
      if (result.body is Map) {
        return (result.body as Map).cast<String, Object?>();
      }
    }
    throw AppNetworkException('UnsupportedType', result.body.toString());
  }

  static Future<List<Map<String, dynamic>>?> parseListJSON(Future<Response> api) async {
    final result = await _parse(api);
    if (result == null) {
      return [];
    }
    if (result.contentType == ContentType.json) {
      if (result.body is List) {
        return List.castFrom<dynamic, Map<String, Object?>>(result.body as List);
      }
      return [];
    }

    throw AppNetworkException('UnsupportedType', result.body.toString());
  }

  static Future<ResponseData?> _parse(Future<Response> api) async {
    final Response response;
    try {
      response = await api;
    } on AppNetworkException {
      rethrow;
    } catch (e) {
      throw AppNetworkException(
        'NetworkError',
        e.toString(),
        details: e.runtimeType.toString(),
      );
    }

    try {
      switch (response.statusCode) {
        case HttpStatus.ok:
          final contentType = response.headers['content-type']?.toLowerCase() ?? '';
          if (contentType.contains('application/json')) {
            return ResponseData(contentType: ContentType.json, body: jsonDecode(response.body));
          }
          return ResponseData(contentType: ContentType.string, body: response.body);
        case HttpStatus.noContent:
          return null;
        default:
          throw AppNetworkException(
            'HttpResponseRrror',
            'Unexpected status code ${response.statusCode}',
            details: response.request?.url.toString(),
            statusCode: response.statusCode,
          );
      }
    } on FormatException catch (e) {
      throw AppNetworkException('ParseError', e.toString(), statusCode: response.statusCode);
    }
  }
}
