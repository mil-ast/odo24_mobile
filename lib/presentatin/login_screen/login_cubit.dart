import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';
import 'package:odo24_mobile/services/auth/models/user_model.dart';

class LoginCubit extends Cubit<AppState> {
  final _authService = AuthService();

  LoginCubit() : super(AppStateDefault());

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      emit(LoginCubitLoginSuccessState(user));
    } catch (e) {
      emit(AppState.catchErrorHandler(e));
    }
  }

  void onClickRegister() {
    emit(LoginCubitOnClickRegisterState());
  }
}

class LoginCubitLoginSuccessState implements AppState {
  final UserModel user;
  const LoginCubitLoginSuccessState(this.user);
}

class LoginCubitOnClickRegisterState extends AppState {}
