import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_repovery_states.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  final IAuthRepository _authRepository;

  PasswordRecoveryCubit({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(PasswordRecoveryState.ready());

  String? validatePin(String? pin) {
    if (pin == null || pin.isEmpty) {
      return 'Введите проверочный код';
    } else if (pin.length < 3) {
      return 'Неверный код';
    }
    return null;
  }

  Future<bool> recoverSendEmailCodeConfirmation(String email) async {
    try {
      emit(PasswordRecoveryState.idle());
      await _authRepository.recoverSendEmailCodeConfirmation(email);
      emit(PasswordRecoveryState.informMessage('Код был отправлен на адрес $email'));
      return true;
    } catch (e) {
      emit(PasswordRecoveryState.failure(e.toString()));
      return false;
    }
  }

  Future<void> saveNewPassword(String email, int code, String newPassword) async {
    try {
      await _authRepository.recoverSaveNewPassword(email, code, newPassword);
      emit(PasswordRecoveryState.success());
    } catch (e) {
      emit(PasswordRecoveryState.failure(e.toString()));
    }
  }
}
