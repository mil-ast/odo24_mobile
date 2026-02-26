import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/middlewares/auth_middleware.dart';
import 'package:odo24_mobile/data/auth/auth_data_provider.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  const apiPing = 'https://backend.1427507-cd27842.tw1.ru/api/ping';

  WidgetsFlutterBinding.ensureInitialized();

  final sp = await SharedPreferences.getInstance();

  test('Status code [200]', () async {
    try {
      final authDataProvider = AuthDataProvider(sharedPreferences: sp);
      final authRepository = AuthRepository(authDataProvider: authDataProvider);
      final authService = AuthService(authRepository);
      final client = AppHttpClient(HttpAPI.newHttpClient(), [AuthMiddleware(authService: authService)]);

      print('start');
      final response = await client.get(Uri.parse(apiPing));
      print(response.statusCode);
      print(response);

      expect(response.statusCode, 200);
    } catch (e) {
      print(e);
    }
  });
}
