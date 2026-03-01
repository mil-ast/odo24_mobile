import 'dart:convert';

import 'package:http/http.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/models/auth_result_model.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IAuthDataProvider {
  String? getAccessToken();
  Future<void> setAccessToken(String token);
  String? getRefreshToken();
  Future<void> setRefreshToken(String token);
  Future<void> removeTokens();
  Future<AuthData?> refreshToken(AuthData currentAuthData);
  Future<AuthResultModel> signInWithEmailAndPassword(String email, String password);
  Future<void> registerSendConfirmationCode(String email);
  Future<void> register(String email, String password, int code);
  Future<void> recoverSendEmailCodeConfirmation(String email);
  Future<void> recoverSaveNewPassword(String email, int code, String password);
  Future<void> changePassword(String currentPassword, String newPassword);
}

class AuthDataProvider implements IAuthDataProvider {
  static const _keyAccessToken = 'auth_bearer_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  final SharedPreferences _sharedPreferences;

  AuthDataProvider({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

  late final AppHttpClient _httpClientWithoutAuth;
  late final AppHttpClient _httpClient;

  void setHttpClients({required AppHttpClient httpClient, required AppHttpClient httpClientWithoutAuth}) {
    _httpClientWithoutAuth = httpClientWithoutAuth;
    _httpClient = httpClient;
  }

  @override
  String? getAccessToken() {
    return _sharedPreferences.getString(_keyAccessToken);
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _sharedPreferences.setString(_keyAccessToken, token);
  }

  @override
  String? getRefreshToken() {
    return _sharedPreferences.getString(_keyRefreshToken);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    await _sharedPreferences.setString(_keyRefreshToken, token);
  }

  @override
  Future<void> removeTokens() async {
    await Future.wait([_sharedPreferences.remove(_keyAccessToken), _sharedPreferences.remove(_keyRefreshToken)]);
  }

  @override
  Future<AuthData?> refreshToken(AuthData currentAuthData) async {
    final authClient = Client();

    final response = await authClient.post(
      Uri.parse('${Configs.baseHost}/api/auth/refresh_token'),
      headers: {'Authorization': 'Bearer ${currentAuthData.accessToken}', 'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': currentAuthData.refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final newAuthData = AuthData.fromStrings(data['access_token'], data['refresh_token']);
      await Future.wait([setAccessToken(newAuthData.accessToken), setRefreshToken(newAuthData.refreshToken)]);
      return newAuthData;
    }
    return null;
  }

  @override
  Future<AuthResultModel> signInWithEmailAndPassword(String email, String password) async {
    final Future<Response> api = _httpClientWithoutAuth.post(
      Uri(path: '/api/auth/login'),
      body: {'login': email, 'password': password},
    );

    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw Exception('signInWithEmailAndPassword: data is empty');
    }

    return AuthResultModel.fromJson(json);
  }

  @override
  Future<void> registerSendConfirmationCode(String email) async {
    final Future<Response> api = _httpClientWithoutAuth.post(
      Uri(path: '/api/register/register_send_code'),
      body: {'email': email},
    );
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> register(String email, String password, int code) async {
    final Future<Response> api = _httpClientWithoutAuth.post(
      Uri(path: '/api/register/register_by_email'),
      body: {'email': email, 'password': password, 'code': code},
    );
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> recoverSendEmailCodeConfirmation(String email) async {
    final Future<Response> api = _httpClientWithoutAuth.post(
      Uri(path: '/api/register/recover_send_code'),
      body: {'email': email},
    );
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> recoverSaveNewPassword(String email, int code, String password) async {
    final Future<Response> api = _httpClientWithoutAuth.post(
      Uri(path: '/api/register/recover_password'),
      body: {'email': email, 'code': code, 'password': password},
    );
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final Future<Response> api = _httpClient.post(
      Uri(path: '/api/auth/change_password'),
      body: {'current_password': currentPassword, 'new_password': newPassword},
    );
    await ResponseHandler.parseJSON(api);
  }
}
