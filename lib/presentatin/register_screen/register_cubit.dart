import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class RegisterCubit extends Cubit<AppState> {
  final _authService = AuthService();

  RegisterCubit() : super(AppStateDefault());

  String? validateEmail(String? email) {
    if (email == null || email.length < 5) {
      return 'Введите ваш Email';
    } else if (!email.contains('@')) {
      return 'Некорректный email';
    }
    return null;
  }

  String? validatePassword(String? passwd) {
    if (passwd == null || passwd.isEmpty) {
      return 'Введите пароль';
    } else if (passwd.length < 6) {
      return 'Пароль слишком короткий';
    }
    return null;
  }

  String? validateConfirmPassword(String? passwd, String? confirmPasswd) {
    if (confirmPasswd == null || confirmPasswd.isEmpty) {
      return 'Повторите пароль';
    } else if (passwd != confirmPasswd) {
      return 'Пароль не совпадает';
    }
    return null;
  }

  String? validateCode(String? code) {
    if (code == null || code.isEmpty) {
      return 'Введите код из e-mail';
    } else if (code.length < 4) {
      return 'Слишком короткий';
    }
    return null;
  }

  void sendRegisterCode(String email) {
    _authService.registerSendConfirmationCode(email).then((_) {
      emit(RegisterCubitSendCodeSuccessState());
    }).catchError((e) {
      emit(AppState.catchErrorHandler(e));
    });
  }

  void register(String email, String password, String code) async {
    try {
      await _authService.register(email, password, int.parse(code));
      emit(RegisterCubitRegisterSuccessState());
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        emit(AppStateError('access.error', 'Проверьте код подтверждения или e-mail'));
      }
      emit(AppStateError('internal.error', 'Произошла ошибка'));
    } catch (e) {
      emit(AppStateError('internal.error', 'Произошла ошибка'));
    }
  }
}

class RegisterCubitListenerState implements AppState {}

class RegisterCubitRegisterSuccessState implements RegisterCubitListenerState {}

class RegisterCubitSendCodeSuccessState implements RegisterCubitListenerState {}
