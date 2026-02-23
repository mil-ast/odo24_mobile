import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/http/models/error_data_model.dart';

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
    //try {
    final response = await api;
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
        throw _handleErrorDataResponse(response);
    }
    /*     } on Exception catch (e) {
      throw AppNetworkException('HttpError', e.toString(), statusCode: response?.statusCode);
    } */
  }

  static AppNetworkException _handleErrorDataResponse(Response res) {
    if (res.body.isEmpty) {
      return AppNetworkException(
        'HttpResponseRrror',
        res.statusCode.toString(),
        details: res.request?.url.toString(),
        statusCode: res.statusCode,
      );
    }
    final data = jsonDecode(res.body);
    if (data is Map) {
      final responseData = ErrorDataModel.fromJson(data.cast<String, Object?>());
      return AppNetworkException(responseData.key, responseData.message, statusCode: res.statusCode);
    }

    return AppNetworkException(
      'HttpResponseRrror',
      data.toString(),
      details: res.request?.url.toString(),
      statusCode: res.statusCode,
    );
  }
}
