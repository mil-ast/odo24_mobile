import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/register/bloc/register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final IAuthRepository _authRepository;

  RegisterCubit({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(RegisterState.ready());

  Future<void> sendRegisterCode(String email, String password) async {
    try {
      emit(RegisterState.waiting());
      await _authRepository.registerSendConfirmationCode(email);
      emit(RegisterState.openEmailConfirmation(email, password));
    } catch (e, st) {
      onError(e, st);
      emit(RegisterState.failure(e));
    }
  }

  Future<void> register({required String email, required String password, required int code}) async {
    try {
      emit(RegisterState.waiting());
      await _authRepository.register(email, password, code);
      emit(RegisterState.success());
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.forbidden) {
        emit(RegisterState.failure('Неверный код подтверждения или email'));
      } else if (e.response?.statusCode == HttpStatus.conflict) {
        emit(RegisterState.failure('Такой email уже занят'));
      } else {
        emit(RegisterState.failure(e));
      }
    } catch (e) {
      emit(RegisterState.failure(e));
    }
  }
}
