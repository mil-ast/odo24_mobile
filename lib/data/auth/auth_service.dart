import 'dart:async';

import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';

class AuthService {
  static late final AuthService instance; //= AuthService._internal();
  AuthService._internal(this._authRepository);

  factory AuthService(IAuthRepository authRepository) {
    instance = AuthService._internal(authRepository);
    return instance;
  }

  final IAuthRepository _authRepository;

  final _authState = StreamController<bool>.broadcast();

  Future<void> logout() async {
    try {
      await _authRepository.removeTokens();
    } finally {
      _authState.sink.add(false);
    }
  }

  AuthData? getAuthData() {
    final authData = _authRepository.getAuthData();
    if (authData == null || authData.isRefreshTokenExpired()) {
      unawaited(_authRepository.removeTokens());
      return null;
    }
    return authData;
  }

  Future<AuthData?> refreshToken(AuthData currentAuthData) => _authRepository.refreshToken(currentAuthData);

  bool get isAuth {
    try {
      final authData = getAuthData();
      return authData != null;
    } catch (e) {
      return false;
    }
  }

  Stream<bool> get authState => _authState.stream;

  Future<void> registerSendConfirmationCode(String email) {
    return _authRepository.registerSendConfirmationCode(email);
  }

  Future<void> register(String email, String password, int code) {
    return _authRepository.register(email, password, code);
  }

  Future<void> changePassword(String currentPassword, String newPassword) {
    return _authRepository.changePassword(currentPassword, newPassword);
  }

  Future<AuthData> signInWithEmailAndPassword(String email, String password) async {
    final newAuthData = await _authRepository.signInWithEmailAndPassword(email, password);
    final authData = AuthData.fromStrings(newAuthData.accessToken, newAuthData.refreshToken);
    _authRepository.updateAuthData(authData);
    _authState.sink.add(true);
    return authData;
  }

  Future<void> recoverSendEmailCodeConfirmation(String email) {
    return _authRepository.recoverSendEmailCodeConfirmation(email);
  }

  Future<void> recoverSaveNewPassword(String email, int code, String password) async {
    return _authRepository.recoverSaveNewPassword(email, code, password);
  }
}
