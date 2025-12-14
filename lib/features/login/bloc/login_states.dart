sealed class LoginState {
  const LoginState();
  factory LoginState.ready() = LoginReadyState;
  factory LoginState.idle() = LoginWaitingState;
  factory LoginState.success(String email) = LoginSuccessState;
  factory LoginState.failure(String message) = LoginErrorState;
  factory LoginState.goToRegister() = LoginGoToRegisterState;
  factory LoginState.goToPasswordRecovery() = LoginGoToPasswordRecoveryState;

  bool get isWaiting => this is LoginWaitingState;
  bool get isReady => this is LoginReadyState;
}

class LoginReadyState extends LoginState {
  const LoginReadyState();
}

class LoginWaitingState extends LoginState {
  const LoginWaitingState();
}

class LoginSuccessState extends LoginState {
  final String email;
  const LoginSuccessState(this.email);
}

class LoginErrorState extends LoginState {
  final String message;
  const LoginErrorState(this.message);
}

class LoginGoToRegisterState extends LoginState {
  const LoginGoToRegisterState();
}

class LoginGoToPasswordRecoveryState extends LoginState {
  const LoginGoToPasswordRecoveryState();
}
