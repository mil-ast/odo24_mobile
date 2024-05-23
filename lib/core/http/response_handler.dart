import 'dart:io';
import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/http/models/error_data_model.dart';

class ResponseHandler {
  static Future<Map<String, dynamic>?> parseJSON(Future<Response<dynamic>> api) async {
    final result = await _parse(api);
    if (result == null) {
      return null;
    } else if (result is List) {
      return result.first;
    }
    return result;
  }

  static Future<List<Map<String, dynamic>>?> parseListJSON(Future<Response<dynamic>> api) async {
    final result = await _parse(api);
    if (result == null) {
      return [];
    } else if (result is List) {
      return List.castFrom<dynamic, Map<String, dynamic>>(result);
    }
    return [result];
  }

  static Future<dynamic> _parse(Future<Response<dynamic>> api) async {
    try {
      final res = await api;
      switch (res.statusCode) {
        case HttpStatus.ok:
          return res.data;
        case HttpStatus.noContent:
          return null;
        default:
          throw _handleErrorDataResponse(res);
      }
    } on DioException catch (e) {
      throw AppNetworkException(
        'HttpError',
        e.message ?? '',
      );
    }
  }

  static AppNetworkException _handleErrorDataResponse(Response<dynamic> res) {
    if (res.data == null) {
      return AppNetworkException(
        'HttpResponseRrror',
        res.statusMessage ?? '',
        details: res.requestOptions.uri.toString(),
      );
    }
    final data = res.data;
    if (data is Map) {
      final responseData = ErrorDataModel.fromJson(data.cast<String, dynamic>());
      return AppNetworkException(
        responseData.key,
        responseData.message,
      );
    }

    return AppNetworkException(
      'HttpResponseRrror',
      data.toString(),
      details: res.requestOptions.uri.toString(),
    );
  }
}
