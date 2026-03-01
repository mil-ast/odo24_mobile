import 'dart:async';

import 'package:odo24_mobile/data/auth/auth_data_provider.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';

abstract interface class IAuthRepository {
  AuthData? getAuthData();
  Future<void> updateAuthData(AuthData newAuthData);
  Future<void> removeTokens();
  Future<AuthData?> refreshToken(AuthData currentAuthData);
  Future<AuthData> signInWithEmailAndPassword(String email, String password);
  Future<void> registerSendConfirmationCode(String email);
  Future<void> register(String email, String password, int code);
  Future<void> recoverSendEmailCodeConfirmation(String email);
  Future<void> recoverSaveNewPassword(String email, int code, String password);
  Future<void> changePassword(String currentPassword, String newPassword);
}

class AuthRepository implements IAuthRepository {
  final IAuthDataProvider _authDataProvider;

  AuthRepository({required IAuthDataProvider authDataProvider}) : _authDataProvider = authDataProvider;

  @override
  AuthData? getAuthData() {
    final accessTokenRaw = _authDataProvider.getAccessToken();
    final refreshTokenRaw = _authDataProvider.getRefreshToken();

    if (accessTokenRaw == null || refreshTokenRaw == null) {
      return null;
    }
    return AuthData.fromStrings(accessTokenRaw, refreshTokenRaw);
  }

  @override
  Future<void> updateAuthData(AuthData newAuthData) async {
    await Future.wait([
      _authDataProvider.setAccessToken(newAuthData.accessToken),
      _authDataProvider.setRefreshToken(newAuthData.refreshToken),
    ]);
  }

  @override
  Future<void> removeTokens() {
    return _authDataProvider.removeTokens();
  }

  @override
  Future<AuthData?> refreshToken(AuthData currentAuthData) {
    return _authDataProvider.refreshToken(currentAuthData);
  }

  @override
  Future<void> registerSendConfirmationCode(String email) {
    return _authDataProvider.registerSendConfirmationCode(email);
  }

  @override
  Future<void> register(String email, String password, int code) {
    return _authDataProvider.register(email, password, code);
  }

  @override
  Future<AuthData> signInWithEmailAndPassword(String email, String password) async {
    final newAuthData = await _authDataProvider.signInWithEmailAndPassword(email, password);
    return AuthData.fromStrings(newAuthData.accessToken, newAuthData.refreshToken);
  }

  @override
  Future<void> recoverSendEmailCodeConfirmation(String email) {
    return _authDataProvider.recoverSendEmailCodeConfirmation(email);
  }

  @override
  Future<void> recoverSaveNewPassword(String email, int code, String password) async {
    return _authDataProvider.recoverSaveNewPassword(email, code, password);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return _authDataProvider.changePassword(currentPassword, newPassword);
  }
}
