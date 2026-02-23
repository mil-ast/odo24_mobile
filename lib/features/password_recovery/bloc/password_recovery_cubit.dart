import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'password_recovery_states.dart';

class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  static const String _spKeyTimeSendCode = 'spKeyTimeSendCode';
  final AuthService _authService;
  final SharedPreferences _sharedPreferences;

  PasswordRecoveryCubit({required AuthService authService, required SharedPreferences sharedPreferences})
    : _authService = authService,
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
        //await _authService.recoverSendEmailCodeConfirmation(email);
        _sharedPreferences.setInt(_spKeyTimeSendCode, now.millisecondsSinceEpoch);
      }

      emit(PasswordRecoveryState.codeSentSuccessfully(email: email, password: password));
    } on AppNetworkException catch (e, st) {
      onError(e, st);
      switch (e.statusCode) {
        case HttpStatus.tooManyRequests:
          emit(PasswordRecoveryState.codeSentSuccessfully(email: email, password: password));
        default:
          emit(PasswordRecoveryState.failure(e.toString()));
      }
    } catch (e, st) {
      onError(e, st);

      emit(const PasswordRecoveryState.failure('Не удалось отправить код'));
    }
  }

  Future<void> recovery({required String email, required String password, required int code}) async {
    try {
      emit(const PasswordRecoveryState.waiting());
      //await _authService.recoverSaveNewPassword(email, code, password);

      emit(const PasswordRecoveryState.successfully());
    } on AppNetworkException catch (e, st) {
      onError(e, st);
      switch (e.statusCode) {
        case HttpStatus.forbidden:
          emit(const PasswordRecoveryState.failure('Неверный код подтверждения или email'));
        default:
          emit(PasswordRecoveryState.failure(e.toString()));
      }
    } catch (e) {
      emit(PasswordRecoveryState.failure(e.toString()));
    }
  }
}
