sealed class LoginState {
  const LoginState();
  factory LoginState.ready() = LoginReadyState;
  factory LoginState.idle() = LoginWaitingState;
  factory LoginState.success(String email) = LoginSuccessState;
  factory LoginState.failure(String message) = LoginErrorState;
  factory LoginState.goToRegister() = LoginGoToRegisterState;
  factory LoginState.goToPasswordRecovery() = LoginGoToPasswordRecoveryState;
}

class LoginReadyState extends LoginState {}

class LoginWaitingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String email;
  const LoginSuccessState(this.email);
}

class LoginErrorState extends LoginState {
  final String message;
  const LoginErrorState(this.message);
}

class LoginGoToRegisterState extends LoginState {}

class LoginGoToPasswordRecoveryState extends LoginState {}
