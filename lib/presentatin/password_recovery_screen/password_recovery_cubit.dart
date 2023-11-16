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

  void recoverSendEmailCodeConfirmation(String email) async {
    try {
      emit(AppStateLoading());
      await _authService.recoverSendEmailCodeConfirmation(email);
      emit(PasswordRecoverySendCodeSuccessState());
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }
}

class PasswordRecoverySendCodeSuccessState implements AppState {}

/* class RegisterCubitListenerState implements AppState {}

class RegisterCubitRegisterSuccessState implements RegisterCubitListenerState {}

class RegisterCubitSendCodeSuccessState implements RegisterCubitListenerState {}
 */