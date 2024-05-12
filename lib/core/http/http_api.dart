import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';

class HttpAPI {
  static const String baseURLHost = 'https://backend.odo24.ru';
  static const String staticBaseURLHost = 'https://odo24.ru';
  static bool _isRefresh = false;

  static String getBaseURLHost() {
    if (kIsWeb && kReleaseMode) {
      return '';
    }
    return baseURLHost;
  }

  static Dio newDio({
    required IAuthRepository authRepository,
    Duration receiveTimeout = const Duration(seconds: 5),
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 5),
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(
      baseUrl: !kIsWeb ? (baseURL ?? baseURLHost) : '',
      contentType: 'application/json',
      validateStatus: (status) {
        return status != null;
      },
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
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          try {
            final authData = await authRepository.getAuthData();

            if (authData == null) {
              if (kDebugMode) {
                print('ODO24: tokenInfo is empty');
              }
              handler.reject(DioException(
                requestOptions: options,
                error: 'Token is empty',
              ));
              return;
            }

            if (authData.isAccessExpired()) {
              if (!_isRefresh) {
                _isRefresh = true;

                if (kDebugMode) {
                  print('ODO24: tokenInfo expired');
                }

                final dio = Dio(
                  BaseOptions(
                    baseUrl: getBaseURLHost(),
                    headers: {
                      'Authorization': 'Bearer ${authData.accessToken}',
                    },
                  ),
                );
                final authResult = await dio.post('/api/auth/refresh_token', data: {
                  'refresh_token': authData.refreshToken,
                });
                final Map<String, dynamic> data = authResult.data;
                final tokenInfo = AuthData.fromStrings(data['access_token'], data['refresh_token']);
                await authRepository.updateAuthData(tokenInfo);

                _isRefresh = false;

                options.headers['Authorization'] = 'Bearer ${tokenInfo.accessToken}';
                handler.next(options);
                return;
              }
            }

            options.headers['Authorization'] = 'Bearer ${authData.accessToken}';
            handler.next(options);
          } catch (e) {
            handler.reject(DioException(
              requestOptions: options,
              error: e.toString(),
            ));
            authRepository.logout();
            rethrow;
          }
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401 && logoutOn401) {
            authRepository.logout();
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
            authRepository.logout();
          }
          return handler.reject(e);
        },
      ),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return dio;
  }
}
