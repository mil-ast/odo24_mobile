import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/models/auth_result_model.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IAuthDataProvider {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String token);
  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String token);
  Future<void> removeTokens();
  Future<void> refreshToken(AuthData currentAuthData);
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

  late final Dio _dioWithoutAuth;
  late final Dio _dio;

  void setHttpClients({
    required Dio dioWithoutAuth,
    required Dio dioWithAuth,
  }) {
    _dioWithoutAuth = dioWithoutAuth;
    _dio = dioWithAuth;
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  @override
  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  @override
  Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRefreshToken, token);
  }

  @override
  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_keyAccessToken),
      prefs.remove(_keyRefreshToken),
    ]);
  }

  @override
  Future<void> refreshToken(AuthData currentAuthData) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: HttpAPI.getBaseURLHost(),
        headers: {
          'Authorization': 'Bearer ${currentAuthData.accessToken}',
        },
      ),
    );
    final authResult = await dio.post('/api/auth/refresh_token', data: {
      'refresh_token': currentAuthData.refreshToken,
    });
    final Map<String, dynamic> data = authResult.data;
    final tokenInfo = AuthData.fromStrings(data['access_token'], data['refresh_token']);

    await Future.wait([
      setAccessToken(tokenInfo.accessToken),
      setRefreshToken(tokenInfo.refreshToken),
    ]);
  }

  @override
  Future<AuthResultModel> signInWithEmailAndPassword(String email, String password) async {
    final api = _dioWithoutAuth.post('/api/auth/login', data: {
      'login': email,
      'password': password,
    });

    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw Exception('signInWithEmailAndPassword: data is empty');
    }

    return AuthResultModel.fromJson(json);
  }

  @override
  Future<void> registerSendConfirmationCode(String email) async {
    final api = _dioWithoutAuth.post('/api/register/register_send_code', data: {
      'email': email,
    });
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> register(String email, String password, int code) async {
    final api = _dioWithoutAuth.post('/api/register/register_by_email', data: {
      'email': email,
      'password': password,
      'code': code,
    });
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> recoverSendEmailCodeConfirmation(String email) async {
    final api = _dioWithoutAuth.post('/api/register/recover_send_code', data: {
      'email': email,
    });
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> recoverSaveNewPassword(String email, int code, String password) async {
    final api = _dioWithoutAuth.post('/api/register/recover_password', data: {
      'email': email,
      'code': code,
      'password': password,
    });
    await ResponseHandler.parseJSON(api);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final api = _dio.post('/api/auth/change_password', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
    await ResponseHandler.parseJSON(api);
  }
}
