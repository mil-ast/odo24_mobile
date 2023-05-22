import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';
import 'package:odo24_mobile/services/auth/models/auth_token.dart';

class HttpAPI {
  static const String _baseURLHost = kDebugMode ? 'http://192.168.1.63:8000' : 'https://odo24.ru';
  static bool _isRefresh = false;

  static Dio newDio({
    int receiveTimeout = 5000,
    int connectTimeout = 5000,
    bool ignoreErrCodes = true,
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(
      baseUrl: baseURL ?? _baseURLHost,
      contentType: 'application/json',
    );
    if (ignoreErrCodes) {
      options.validateStatus = (status) {
        return status != null;
      };
    }
    options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    options.connectTimeout = Duration(milliseconds: connectTimeout);
    options.sendTimeout = Duration(milliseconds: receiveTimeout);
    final dio = Dio(options);

    if (allowBadCertificate == true) {
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (_) {
          final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        }
        ..validateCertificate = (cert, host, port) => cert != null;
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
              handler.reject(DioError(
                requestOptions: options,
                error: 'Token is empty',
              ));
            }

            AuthService().logout();
          } catch (e) {
            handler.reject(DioError(
              requestOptions: options,
              error: e.toString(),
            ));
            AuthService().logout();
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
        onError: (DioError e, handler) async {
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
    int receiveTimeout = 5000,
    int connectTimeout = 5000,
    bool ignoreErrCodes = true,
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(
      baseUrl: baseURL ?? _baseURLHost,
    );
    if (ignoreErrCodes) {
      options.validateStatus = (status) {
        return status != null;
      };
    }

    options.receiveTimeout = Duration(milliseconds: receiveTimeout);
    options.connectTimeout = Duration(milliseconds: connectTimeout);
    options.sendTimeout = Duration(milliseconds: receiveTimeout);

    final Dio d = Dio(options);
    if (allowBadCertificate == true) {
      d.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (_) {
          final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        }
        ..validateCertificate = (cert, host, port) => cert != null;
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
        onError: (DioError e, handler) async {
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
