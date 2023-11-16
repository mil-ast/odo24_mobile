import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/api/auth/auth.api.dart';
import 'package:odo24_mobile/data/repository/auth/auth_result.dto.dart';

final class AuthRepository {
  final _api = AuthApi();

  Future<AuthResultDTO> signInWithEmailAndPassword(String email, String password) async {
    final api = _api.signInWithEmailAndPassword(email, password);

    final json = await ResponseHandler.parseJSON(api);
    return AuthResultDTO.fromJson(json);
  }

  Future<void> registerSendConfirmationCode(String email) async {
    final api = _api.registerSendConfirmationCode(email);
    await ResponseHandler.parseJSON(api);
  }

  Future<void> register(String email, String password, int code) async {
    final api = _api.register(email, password, code);
    await ResponseHandler.parseJSON(api);
  }

  Future<void> recoverSendEmailCodeConfirmation(String email) async {
    final api = _api.recoverSendEmailCodeConfirmation(email);
    await ResponseHandler.parseJSON(api);
  }
}
