import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/services/auth/auth_service.dart';

class PasswordRecoveryCubit extends Cubit<AppState> {
  final _authService = AuthService();

  PasswordRecoveryCubit() : super(AppStateDefault());

  String? validateEmail(String? email) {
    if (email == null || email.length < 5) {
      return 'Введите ваш Email';
    } else if (!email.contains('@')) {
      return 'Некорректный email';
    }
    return null;
  }

  String? validateNewPassword(String? passwd) {
    if (passwd == null || passwd.isEmpty) {
      return 'Введите пароль';
    } else if (passwd.length < 6) {
      return 'Пароль слишком короткий';
    }
    return null;
  }

  String? validateConfirmPassword(String passwd, String? confirmPassword) {
    if (confirmPassword == null) {
      return null;
    }
    if (confirmPassword.isEmpty) {
      return 'Повторите пароль';
    } else if (passwd != confirmPassword) {
      return 'Пароль не совпадает';
    }
    return null;
  }

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
      emit(AppStateLoading());
      await _authService.recoverSendEmailCodeConfirmation(email);
      emit(PasswordRecoverySendCodeSuccessState(email));
      return true;
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
      return false;
    }
  }

  void saveNewPassword(String email, int code, String newPassword) async {
    try {
      await _authService.registerSaveNewPassword(email, code, newPassword);
      emit(PasswordRecoverySuccessState());
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}

class PasswordRecoverySendCodeSuccessState implements AppState {
  final String email;
  PasswordRecoverySendCodeSuccessState(this.email);
}

class PasswordRecoverySuccessState implements AppState {}

/* class RegisterCubitListenerState implements AppState {}

class RegisterCubitRegisterSuccessState implements RegisterCubitListenerState {}

class RegisterCubitSendCodeSuccessState implements RegisterCubitListenerState {}
 */