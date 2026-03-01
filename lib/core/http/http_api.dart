import 'dart:convert';
import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';
import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';

class AppHttpClient extends BaseClient {
  final Client _inner;
  late final NextFunction _pipeline;

  AppHttpClient(this._inner, List<Middleware> middlewares) {
    // Собираем цепочку вызовов в один пайплайн
    _pipeline = middlewares.reversed.fold(
      (BaseRequest request) => _inner.send(request),
      (NextFunction next, Middleware middleware) =>
          (BaseRequest request) => middleware.execute(request, next),
    );
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    return super.get(_urlToFull(url), headers: headers);
  }

  @override
  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.post(_urlToFull(url), body: _toJsonString(body), headers: headers, encoding: encoding);
  }

  @override
  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.put(_urlToFull(url), body: _toJsonString(body), headers: headers, encoding: encoding);
  }

  @override
  Future<Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return super.delete(_urlToFull(url), headers: headers, body: _toJsonString(body), encoding: encoding);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) => _pipeline(request);

  String? _toJsonString(Object? data) {
    return switch (data) {
      JsonSerializable() => jsonEncode(data),
      Map() => jsonEncode(data),
      Object() => jsonEncode(data),
      null => null,
    };
  }

  Uri _urlToFull(Uri url) {
    final isAbsolute = url.hasScheme;
    if (!isAbsolute) {
      return Uri.parse('${Configs.baseHost}$url');
    }
    return url;
  }
}

class HttpAPI {
  static String get baseHost {
    return Configs.baseHost;
  }

  static Client newHttpClient() {
    if (Platform.isAndroid) {
      final engine = CronetEngine.build(
        cacheMode: CacheMode.disabled,
        //cacheMaxSize: 2 * 1024 * 1024,
        enableQuic: true,
        enableHttp2: true,
      );
      return CronetClient.fromCronetEngine(engine, closeEngine: true);
    } else {
      return IOClient(HttpClient());
    }
  }

  /* static Dio newDio({
    required IAuthRepository authRepository,
    Duration receiveTimeout = const Duration(seconds: 5),
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 5),
    bool logoutOn401 = true,
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options =
        BaseOptions(baseUrl: baseHost, contentType: 'application/json', validateStatus: (status) => status != null)
          ..receiveTimeout = receiveTimeout
          ..connectTimeout = connectTimeout
          ..sendTimeout = sendTimeout
          ..validateStatus = (status) => status != null;

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
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          try {
            final authData = await authRepository.getAuthData();

            if (authData == null) {
              if (kDebugMode) {
                print('ODO24: tokenInfo is empty');
              }
              handler.reject(DioException(requestOptions: options, error: 'Token is empty'));
              return;
            }

            if (authData.isAccessExpired()) {
              if (!_isRefresh) {
                _isRefresh = true;

                if (kDebugMode) {
                  print('ODO24: tokenInfo expired');
                }

                final dio = Dio(
                  BaseOptions(baseUrl: baseHost, headers: {'Authorization': 'Bearer ${authData.accessToken}'}),
                );
                final authResult = await dio.post(
                  '/api/auth/refresh_token',
                  data: {'refresh_token': authData.refreshToken},
                );
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
            handler.reject(DioException(requestOptions: options, error: e.toString()));
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

  static Dio newDioWithoutAuth({
    Duration receiveTimeout = const Duration(seconds: 5),
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 5),
    bool forceJsonContent = false, // true - если в ответе нет хедера application/json
    bool allowBadCertificate = false,
    String? baseURL,
  }) {
    final options = BaseOptions(baseUrl: baseHost, contentType: 'application/json', validateStatus: (status) => true);
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

    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    }

    return dio;
  } */
}
