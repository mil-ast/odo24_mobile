import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/repository/auth/auth.repository.dart';
import 'package:odo24_mobile/services/auth/models/auth_token.dart';
import 'package:odo24_mobile/services/auth/models/user_model.dart';

class AuthService {
  static const _keyBearerToken = 'auth_bearer_token';
  static const _keyRefreshToken = 'auth_refresh_token';

  static final _instance = AuthService._internal();
  static final _secureStorage = FlutterSecureStorage();
  static final _authRepository = AuthRepository();

  AuthToken? authToken;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> saveAuthToken(AuthToken token) {
    authToken = token;
    return Future.wait([
      _secureStorage.write(key: _keyBearerToken, value: token.accessToken),
      _secureStorage.write(key: _keyRefreshToken, value: token.refreshToken),
    ]);
  }

  Future<AuthToken?> getAuthToken() async {
    if (authToken != null) {
      return authToken;
    }
    final storageData = await Future.wait<String?>([
      _secureStorage.read(key: _keyBearerToken),
      _secureStorage.read(key: _keyRefreshToken),
    ]);

    if (storageData[0] == null || storageData[1] == null) {
      return null;
    }

    authToken = AuthToken.fromStrings(storageData[0]!, storageData[1]!);
    return authToken;
  }

  Future<bool> isAuth() async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        return false;
      }

      if (token.isRefreshTokenExpired()) {
        return false;
      }

      /* if (token.isExpired()) {
        final newToken = await refreshToken(token);
        await saveAuthToken(newToken);
      } */

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> registerSendConfirmationCode(String email) {
    return _authRepository.registerSendConfirmationCode(email);
  }

  Future<void> register(String email, String password, int code) {
    return _authRepository.register(email, password, code);
  }

  Future<UserModel> signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password).then((dto) {
      final token = UserModel.fromDTO(email, dto);
      saveAuthToken(token.token);
      return token;
    });
  }

  void logout() {
    Future.wait([
      _secureStorage.delete(key: _keyBearerToken),
      _secureStorage.delete(key: _keyRefreshToken),
    ]);

    authToken = null;

    Odo24App.navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
