import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/auth/auth_result.dto.dart';
import 'package:odo24_mobile/services/auth/models/auth_token.dart';

class AuthRepository {
  final _api = HttpAPI.newDio();
  final _apiWithoutAuth = HttpAPI.newDioWithoutAuth();

  Future<AuthResultDTO> signInWithEmailAndPassword(String email, String password) async {
    final result = await _apiWithoutAuth.post('/api/auth/login', data: {
      'login': email,
      'password': password,
    });

    final json = ResponseHandler.parse(result);
    return AuthResultDTO.fromJson(json);
  }

  Future<AuthResultDTO> refreshToken(AuthToken token) async {
    final result = await _api.post('/api/auth/refresh_token', data: {
      'refresh_token': token.refreshToken,
    });

    final json = ResponseHandler.parse(result);
    return AuthResultDTO.fromJson(json);
  }
}