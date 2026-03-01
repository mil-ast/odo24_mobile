import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService;
  LoginCubit({required AuthService authService}) : _authService = authService, super(LoginState.ready());

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(LoginState.idle());
      await _authService.signInWithEmailAndPassword(email, password);
      emit(LoginState.success(email));
    } on AppNetworkException catch (e) {
      switch (e.statusCode) {
        case HttpStatus.unauthorized:
          emit(LoginState.failure('Неверный логин или пароль'));
        default:
          emit(LoginState.failure(e.toString()));
      }
    } catch (e) {
      emit(LoginState.failure(e.toString()));
    } finally {
      emit(LoginState.ready());
    }
  }

  void onClickRegister() {
    emit(LoginState.goToRegister());
  }

  void onClickPasswordRecovery() {
    emit(LoginState.goToPasswordRecovery());
  }
}
