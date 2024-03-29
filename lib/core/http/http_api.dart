import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:odo24_mobile/domain/services/auth/auth_service.dart';
import 'package:odo24_mobile/domain/services/auth/models/auth_token.dart';

class HttpAPI {
  static const String _baseURLHost = 'https://backend.odo24.ru';
  //static const String _baseURLHost = 'http://0.0.0.0:8000';
  static bool _isRefresh = false;

  static Dio newDio({
    Duration receiveTimeout = const Duration(seconds: 5),
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 5),
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(
      baseUrl: baseURL ?? _baseURLHost,
      contentType: 'application/json',
    );
    options.receiveTimeout = receiveTimeout;
    options.connectTimeout = connectTimeout;
    options.sendTimeout = sendTimeout;
    options.validateStatus = (status) => status != null;
    final dio = Dio(options);

    if (allowBadCertificate == true) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      )..validateCertificate = (cert, host, port) => cert != null;
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        //Интерсептор подстановки авторизации
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          try {
            AuthToken? tokenInfo = await AuthService().getAuthToken();
            if (tokenInfo != null) {
              if (tokenInfo.isExpired() && !_isRefresh) {
                _isRefresh = true;

                if (kDebugMode) {
                  print('ODO24: tokenInfo expired');
                }

                final d = Dio(
                  BaseOptions(
                    baseUrl: _baseURLHost,
                    headers: {
                      'Authorization': 'Bearer ${tokenInfo.accessToken}',
                    },
                  ),
                );
                final authResult = await d.post('/api/auth/refresh_token', data: {
                  'refresh_token': tokenInfo.refreshToken,
                }).whenComplete(() {
                  _isRefresh = false;
                });
                final Map<String, dynamic> data = authResult.data;
                tokenInfo = AuthToken.fromStrings(data['access_token'], data['refresh_token']);
                AuthService().saveAuthToken(tokenInfo);
              }

              options.headers['Authorization'] = 'Bearer ${tokenInfo.accessToken}';
              handler.next(options);
              return;
            } else {
              handler.reject(DioException(
                requestOptions: options,
                error: 'Token is empty',
              ));
            }

            AuthService().logout();
          } catch (e) {
            handler.reject(DioException(
              requestOptions: options,
              error: e.toString(),
            ));
            AuthService().logout();
            rethrow;
          }
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401 && logoutOn401) {
            AuthService().logout();
            return handler.next(response);
          }

          if (response.statusCode == 204 || (response.data.runtimeType == String && response.data == '')) {
            response.data = {'data': null};
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response == null) {
            return handler.reject(e);
          }

          if (e.response != null && e.response!.statusCode == 401) {
            AuthService().logout();
          }
          return handler.reject(e);
        },
      ),
    );

    if (forceJsonContent) {
      dio.interceptors.add(
        //Чтобы парсилось в json даже если бэком не установлен хэдер application/json
        InterceptorsWrapper(
          onResponse: (response, handler) {
            if (response.data.runtimeType == String) {
              response.data = jsonDecode(response.data);
            }
            handler.next(response);
          },
        ),
      );
    }

    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return dio;
  }

  static Dio newDioWithoutAuth({
    Duration receiveTimeout = const Duration(seconds: 5),
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 5),
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(
      baseUrl: baseURL ?? _baseURLHost,
    );
    options.validateStatus = (status) => status != null;

    options.receiveTimeout = receiveTimeout;
    options.connectTimeout = connectTimeout;
    options.sendTimeout = sendTimeout;

    final Dio d = Dio(options);
    if (allowBadCertificate == true) {
      d.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      )..validateCertificate = (cert, host, port) => cert != null;
    }

    d.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          if (response.statusCode == 401 && logoutOn401) {
            AuthService().logout();
            return handler.next(response);
          }

          if (response.statusCode == 204 || (response.data.runtimeType == String && response.data == '')) {
            response.data = {'data': null};
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response == null) {
            return handler.reject(e);
          }
          if (e.response != null && e.response!.statusCode == 401) {
            AuthService().logout();
          }
          return handler.reject(e);
        },
      ),
    );

    if (forceJsonContent) {
      d.interceptors.add(
        //Чтобы парсилось в json даже если бэком не установлен хэдер application/json
        InterceptorsWrapper(
          onResponse: (response, handler) {
            if (response.data.runtimeType == String) {
              response.data = jsonDecode(response.data);
            }
            handler.next(response);
          },
        ),
      );
    }

    if (!kReleaseMode) {
      d.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return d;
  }
}
