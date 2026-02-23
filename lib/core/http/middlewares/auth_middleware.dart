import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:odo24_mobile/data/models/auth_token.dart';

base class AuthMiddleware extends Middleware {
  static Future<AuthData?>? _refreshFuture;

  final AuthService _authService;
  AuthMiddleware({required AuthService authService}) : _authService = authService;

  @override
  Future<StreamedResponse> execute(BaseRequest request, NextFunction next) async {
    final authData = _authService.getAuthData();
    if (authData == null) {
      if (kDebugMode) {
        print('ODO24: authData is empty');
      }
      AuthService.instance.logout();
      throw Exception('No JWT token found');
    }
    // Добавляем текущий токен
    request.headers['Authorization'] = 'Bearer ${authData.accessToken}';

    if (authData.isAccessExpired()) {
      final newAuthData = await _performRefreshToken(authData);
      if (newAuthData != null) {
        // клонируем запрос, подставляем НОВЫЙ токен
        final retryRequest = _cloneRequest(request)..headers['Authorization'] = 'Bearer ${newAuthData.accessToken}';
        return await next(retryRequest);
      }
    }

    return await next(request);
  }

  Future<AuthData?> _performRefreshToken(AuthData authData) async {
    // Если обновление уже идет, просто ждем завершения текущего Future
    if (_refreshFuture != null) {
      return _refreshFuture;
    }

    _refreshFuture = () async {
      try {
        return await _authService.refreshToken(authData);
      } catch (e) {
        return null;
      } finally {
        _refreshFuture = null;
      }
    }();

    return _refreshFuture;
  }

  BaseRequest _cloneRequest(BaseRequest request) {
    if (request is Request) {
      final copy = Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..bodyBytes = request.bodyBytes;
      return copy;
    }
    return request;
  }
}
