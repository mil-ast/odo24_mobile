import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/data/api/auth/auth.api.dart';
import 'package:odo24_mobile/data/repository/auth/auth_result.dto.dart';

final class AuthRepository {
  final _api = AuthApi();

  Future<AuthResultDTO> signInWithEmailAndPassword(String email, String password) async {
    final api = _api.signInWithEmailAndPassword(email, password);

    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw AppStateError('repository.auth.create', 'Произошла ошибка при авторизации');
    }
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

  Future<void> registerSaveNewPassword(String email, int code, String password) async {
    final api = _api.registerSaveNewPassword(email, code, password);
    await ResponseHandler.parseJSON(api);
  }
}
