import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class LoginCubit extends Cubit<AppState> {
  final _authService = AuthService();

  LoginCubit() : super(AppStateDefault());

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

  void login(String login, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(
        login,
        password,
      );

      emit(LoginCubitLoginSuccessState());
    } on FirebaseException {
      emit(AppStateError('firebase.exception', 'Неправильный логин или пароль'));
    } catch (e) {
      emit(AppStateError('internal.error', 'Произошла внутренняя ошибка'));
    }
  }

  void onClickRegister() {
    emit(LoginCubitOnClickRegisterState());
  }
}

class LoginCubitLoginSuccessState extends AppState {}

class LoginCubitOnClickRegisterState extends AppState {}
