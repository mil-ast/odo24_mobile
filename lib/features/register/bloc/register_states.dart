sealed class RegisterState {
  const RegisterState();
  factory RegisterState.ready() = RegisterReadyState;
  factory RegisterState.waiting() = RegisterWaitingState;
  factory RegisterState.openEmailConfirmation(String email, String password) = RegisterOpenEmailConfirmationState;
  factory RegisterState.success() = RegisterSuccessState;
  factory RegisterState.message(String message) = RegisterMessageState;
  factory RegisterState.failure(Object message) => RegisterErrorState(message.toString());

  bool get isWaiting => this is RegisterWaitingState;
  bool get isReady => this is RegisterReadyState;
  bool get isSuccess => this is RegisterOpenEmailConfirmationState;
  bool get isCompeted => this is RegisterSuccessState;
  bool get hasError => this is RegisterErrorState;
}

class RegisterReadyState extends RegisterState {
  const RegisterReadyState();
}

class RegisterWaitingState extends RegisterState {
  const RegisterWaitingState();
}

class RegisterOpenEmailConfirmationState extends RegisterState {
  final String email;
  final String password;
  const RegisterOpenEmailConfirmationState(this.email, this.password);
}

class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState();
}

class RegisterMessageState extends RegisterState {
  final String message;
  const RegisterMessageState(this.message);
}

class RegisterErrorState extends RegisterState {
  final String message;
  const RegisterErrorState(this.message);
}
