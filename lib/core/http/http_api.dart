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
    print(body);
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
        enableQuic: true,
        enableHttp2: true,
        userAgent: 'ODO24Mobile',
      );
      return CronetClient.fromCronetEngine(engine, closeEngine: true);
    } else {
      return IOClient(HttpClient());
    }
  }
}
