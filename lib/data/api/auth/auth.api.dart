import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/http_api.dart';

class AuthApi {
  final _apiWithoutAuth = HttpAPI.newDioWithoutAuth();

  Future<Response> signInWithEmailAndPassword(String email, String password) {
    return _apiWithoutAuth.post('/api/auth/login', data: {
      'login': email,
      'password': password,
    });
  }

  Future<Response> registerSendConfirmationCode(String email) {
    return _apiWithoutAuth.post('/api/register/register_send_code', data: {
      'email': email,
    });
  }

  Future<Response> register(String email, String password, int code) {
    return _apiWithoutAuth.post('/api/register/register_by_email', data: {
      'email': email,
      'password': password,
      'code': code,
    });
  }

  Future<Response> recoverSendEmailCodeConfirmation(String email) {
    return _apiWithoutAuth.post('/api/register/recover_send_code', data: {
      'email': email,
    });
  }
}
