import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';

part 'register_states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService;

  RegisterCubit({required AuthService authService}) : _authService = authService, super(RegisterState.ready());

  Future<void> sendRegisterCode(String email, String password) async {
    try {
      emit(RegisterState.waiting());
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        await _authService.registerSendConfirmationCode(email);
      }

      emit(RegisterState.openEmailConfirmation(email, password));
    } on AppNetworkException catch (e, st) {
      onError(e, st);

      switch (e.statusCode) {
        case HttpStatus.tooManyRequests:
          emit(RegisterState.openEmailConfirmation(email, password));
        default:
          emit(RegisterState.failure(e.toString()));
      }
    } catch (e, st) {
      onError(e, st);
      emit(RegisterState.failure(e));
    }
  }

  Future<void> register({required String email, required String password, required int code}) async {
    try {
      emit(RegisterState.waiting());
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        await _authService.register(email, password, code);
      }
      emit(RegisterState.success());
    } on AppNetworkException catch (e, st) {
      onError(e, st);
      switch (e.statusCode) {
        case HttpStatus.forbidden:
          emit(RegisterState.failure('Неверный код подтверждения или email'));
        case HttpStatus.conflict:
          emit(RegisterState.failure('Такой email уже занят'));
        default:
          emit(RegisterState.failure(e));
      }
    } catch (e, st) {
      onError(e, st);
      emit(RegisterState.failure(e));
    }
  }
}
