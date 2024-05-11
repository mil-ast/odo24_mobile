import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository _authRepository;
  LoginCubit({
    required IAuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState.ready());

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(LoginState.idle());
      final authResult = await _authRepository.signInWithEmailAndPassword(email, password);
      await _authRepository.updateAuthData(authResult);
      emit(LoginState.success(email));
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        emit(LoginState.failure('Неверный логин или пароль'));
      } else {
        emit(LoginState.failure(e.toString()));
      }
      emit(LoginState.ready());
    } catch (e) {
      emit(LoginState.failure(e.toString()));
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
