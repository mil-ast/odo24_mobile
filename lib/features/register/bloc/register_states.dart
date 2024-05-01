sealed class RegisterState {
  const RegisterState();
  factory RegisterState.ready() = RegisterReadyState;
  factory RegisterState.idle() = RegisterWaitingState;
  factory RegisterState.success() = RegisterSuccessState;
  factory RegisterState.message(String message) = RegisterMessageState;
  factory RegisterState.failure(String message) = RegisterErrorState;
}

class RegisterReadyState extends RegisterState {}

class RegisterWaitingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterMessageState extends RegisterState {
  final String message;
  const RegisterMessageState(this.message);
}

class RegisterErrorState extends RegisterState {
  final String message;
  const RegisterErrorState(this.message);
}
