import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/repository/auth/auth_result.dto.dart';

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

  Future<void> registerSendConfirmationCode(String email) {
    return _apiWithoutAuth.post('/api/register/register_send_code', data: {
      'email': email,
    });
  }

  Future<void> register(String email, String password, int code) {
    return _apiWithoutAuth.post('/api/register/register_by_email', data: {
      'email': email,
      'password': password,
      'code': code,
    });
  }
}
