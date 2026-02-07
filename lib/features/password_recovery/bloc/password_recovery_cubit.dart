import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'password_recovery_states.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  static const String _spKeyTimeSendCode = 'spKeyTimeSendCode';
  final IAuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;

  PasswordRecoveryCubit({required IAuthRepository authRepository, required SharedPreferences sharedPreferences})
    : _authRepository = authRepository,
      _sharedPreferences = sharedPreferences,
      super(const PasswordRecoveryState.ready());

  Future<void> submitForm({required String email, required String password}) async {
    try {
      emit(const PasswordRecoveryState.waiting());

      final time =
          _sharedPreferences.getInt(_spKeyTimeSendCode) ??
          DateTime.now().subtract(Configs.sendEmailDuration + const Duration(seconds: 1)).millisecondsSinceEpoch;

      final dt = DateTime.fromMillisecondsSinceEpoch(time);
      final now = DateTime.now();
      if (dt.add(Configs.sendEmailDuration).isBefore(now)) {
        await _authRepository.recoverSendEmailCodeConfirmation(email);
        _sharedPreferences.setInt(_spKeyTimeSendCode, now.millisecondsSinceEpoch);
      }

      emit(PasswordRecoveryState.codeSentSuccessfully(email: email, password: password));
    } catch (e, st) {
      onError(e, st);

      emit(PasswordRecoveryState.failure(AppException('Не удалось отправить код', details: e.toString())));
    }
  }

  Future<void> recovery({required String email, required String password, required int code}) async {
    try {
      emit(const PasswordRecoveryState.waiting());
      await _authRepository.recoverSaveNewPassword(email, code, password);

      emit(const PasswordRecoveryState.successfully());
    } catch (e) {
      emit(PasswordRecoveryState.failure(AppException('Ошибка при восстановлении пароля', details: e.toString())));
    }
  }
}
