import 'dart:io';
import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/app_state_core.dart';

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
    if (result is List) {
      return List.castFrom<dynamic, Map<String, dynamic>>(result);
    }
    return [result];
  }

  static Future<dynamic> _parse(Future<Response<dynamic>> api) async {
    final res = await api;
    switch (res.statusCode) {
      case HttpStatus.ok:
        return res.data;
      case HttpStatus.noContent:
        return null;
      case HttpStatus.badRequest:
        throw AppStateError(
          'http.badRequest',
          'Неверный запрос',
          details: res.requestOptions.uri.toString(),
        );
      case HttpStatus.unauthorized:
        throw AppStateError(
          'http.unauthorized',
          'Ошибка авторизации',
          details: res.requestOptions.uri.toString(),
        );
      case HttpStatus.notFound:
        throw AppStateError(
          'http.notFound',
          'Страница не найдена',
          details: res.requestOptions.uri.toString(),
        );
      default:
        throw AppStateError(
          'http.error',
          'Ошибка, ${res.statusCode}, ${res.statusMessage}',
          details: res.statusMessage,
        );
    }
  }
}
