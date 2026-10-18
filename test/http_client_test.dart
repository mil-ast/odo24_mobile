import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/middlewares/json_middleware.dart';
import 'package:odo24_mobile/core/http/middlewares/status_code_middleware.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';

void main() {
  const baseHost = 'https://1427507-cd27842.tw1.ru';
  const jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

  group('AppHttpClient', () {
    test('добавляет базовый хост к относительному URL и ставит JSON-заголовки', () async {
      final inner = MockClient((request) async {
        expect(request.url.toString(), '$baseHost/api/ping');
        expect(request.headers['content-type'], jsonHeaders['content-type']);
        expect(request.headers['accept'], 'application/json');
        return http.Response('{"ok":true}', 200, headers: jsonHeaders);
      });

      final client = AppHttpClient(inner, const [JsonContentTypeMiddleware(), StatusCodeMiddleware()]);
      final res = await client.get(Uri(path: '/api/ping'));

      expect(res.statusCode, 200);
    });

    test('кодирует Map body в JSON на POST', () async {
      final inner = MockClient((request) async {
        expect(request.method, 'POST');
        expect(jsonDecode(request.body), {'login': 'a@b.ru', 'password': 'secret'});
        return http.Response('{}', 200, headers: jsonHeaders);
      });

      final client = AppHttpClient(inner, const [JsonContentTypeMiddleware(), StatusCodeMiddleware()]);
      final res = await client.post(Uri(path: '/api/auth/login'), body: {'login': 'a@b.ru', 'password': 'secret'});

      expect(res.statusCode, 200);
    });

    test('бросает AppNetworkException при статусе >= 400', () async {
      final inner = MockClient((request) async => http.Response('boom', 500));

      final client = AppHttpClient(inner, const [StatusCodeMiddleware()]);

      await expectLater(client.get(Uri(path: '/api/err')), throwsA(isA<AppNetworkException>()));
    });
  });

  group('ResponseHandler', () {
    test('parseJSON возвращает декодированный Map', () async {
      final inner = MockClient((request) async => http.Response('{"message":"ok"}', 200, headers: jsonHeaders));
      final client = AppHttpClient(inner, const [JsonContentTypeMiddleware(), StatusCodeMiddleware()]);

      final parsed = await ResponseHandler.parseJSON(client.get(Uri(path: '/api/x')));

      expect(parsed, {'message': 'ok'});
    });
  });
}
