import 'package:odo24_mobile/data/auth/auth_data_provider.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';
import 'package:odo24_mobile/main.dart';

abstract interface class IAuthRepository {
  Future<bool> get isAuth;
  Future<AuthData?> getAuthData();
  Future<void> updateAuthData(AuthData newAuthData);
  Future<void> removeTokens();
  Future<void> refreshToken(AuthData currentAuthData);
  Future<AuthData> signInWithEmailAndPassword(String email, String password);
  Future<void> registerSendConfirmationCode(String email);
  Future<void> register(String email, String password, int code);
  Future<void> recoverSendEmailCodeConfirmation(String email);
  Future<void> recoverSaveNewPassword(String email, int code, String password);
  Future<void> logout();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataProvider _authDataProvider;

  AuthRepository({
    required IAuthDataProvider authDataProvider,
  }) : _authDataProvider = authDataProvider;

  @override
  Future<bool> get isAuth async {
    try {
      final authData = await getAuthData();
      if (authData == null) {
        return false;
      }
      if (authData.isAccessExpired()) {
        await _authDataProvider.refreshToken(authData);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthData?> getAuthData() async {
    final tokens = await Future.wait<String?>([
      _authDataProvider.getAccessToken(),
      _authDataProvider.getRefreshToken(),
    ]);
    final [accessTokenRaw, refreshTokenRaw] = tokens;
    if (accessTokenRaw == null || refreshTokenRaw == null) {
      await _authDataProvider.removeTokens();
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
  Future<void> refreshToken(AuthData currentAuthData) async {
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
  Future<void> logout() {
    return removeTokens();
  }
}
