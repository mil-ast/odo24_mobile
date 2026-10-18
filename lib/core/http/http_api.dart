import 'dart:convert';
import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';
import 'package:odo24_mobile/core/http/models/json_serializable_interface.dart';
import 'package:odo24_mobile/core/http/network_error.dart';

class AppHttpClient extends BaseClient {
  final Client _inner;
  final List<String> _hosts;
  final Duration _perHostTimeout;
  late final NextFunction _pipeline;
  // Подсказка: индекс хоста, который успешно отвечал в последний раз.
  int _activeHostIndex = 0;

  AppHttpClient(
    this._inner,
    List<Middleware> middlewares, {
    this._perHostTimeout = const Duration(seconds: 5),
    Set<String> hosts = Configs.baseHosts,
  }) : _hosts = hosts.isEmpty ? List.unmodifiable([Configs.baseHost]) : List.unmodifiable(hosts) {
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
  Future<StreamedResponse> send(BaseRequest request) async {
    // Стартуем с хоста, к которому относится URL запроса (обычно последний рабочий),
    // и при сетевой ошибке перебираем остальные хосты по кругу.
    final startIndex = _hostIndexOf(request.url);
    Object? lastError;

    for (var offset = 0; offset < _hosts.length; offset++) {
      final index = (startIndex + offset) % _hosts.length;
      final attempt = _buildAttempt(request, _hosts[index]);

      try {
        final response = await _pipeline(attempt).timeout(_perHostTimeout);
        _activeHostIndex = index; // запоминаем рабочий хост
        return response;
      } catch (e) {
        if (!isRetriableNetworkError(e)) {
          rethrow; // не-сетевая ошибка (например 4xx/5xx или TLS) — без переключения
        }
        lastError = e;
      }
    }

    // Все хосты недоступны
    throw lastError ?? const AppNetworkException('NetworkError', 'Все хосты недоступны');
  }

  /// Сопоставляет scheme/host/port URL запроса с элементом списка хостов.
  int _hostIndexOf(Uri url) {
    final scheme = url.scheme;
    final host = url.host;
    final port = url.hasPort ? url.port : null;

    for (var i = 0; i < _hosts.length; i++) {
      final base = Uri.parse(_hosts[i]);
      if (base.scheme == scheme && base.host == host && (port == null || (base.hasPort && base.port == port))) {
        return i;
      }
    }
    return 0;
  }

  /// Создаёт НОВЫЙ запрос на нужный хост. Пересоздание обязательно:
  /// после первого [finalize] тело запроса может стать недоступным,
  /// а повторный send того же объекта бросает StateError.
  Request _buildAttempt(BaseRequest request, String baseHost) {
    final target = Uri.parse(baseHost);
    final url = request.url.replace(
      scheme: target.scheme,
      host: target.host,
      port: target.hasPort ? target.port : null,
    );
    final bodyBytes = request is Request ? request.bodyBytes : const <int>[];
    return Request(request.method, url)
      ..headers.addAll(request.headers)
      ..bodyBytes = bodyBytes;
  }

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
      return Uri.parse('${_hosts[_activeHostIndex]}$url');
    }
    return url;
  }
}

class HttpAPI {
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
