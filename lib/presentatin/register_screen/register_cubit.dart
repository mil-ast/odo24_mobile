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

  void register(String email, String password) async {
    try {
      /* await _authService.sendSignInLinkToEmail(
        email,
        //password,
      ); */

      emit(RegisterCubitRegisterSuccessState());
    } catch (e) {
      emit(AppStateError('internal.error', 'Неправильный логин или пароль'));
    }
  }
}

class RegisterCubitRegisterSuccessState extends AppState {}
