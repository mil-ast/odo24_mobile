sealed class RegisterState {
  final bool isBuild;
  const RegisterState(this.isBuild);
  factory RegisterState.ready() = RegisterReadyState;
  factory RegisterState.idle() = RegisterWaitingState;
  factory RegisterState.success() = RegisterSuccessState;
  factory RegisterState.message(String message) = RegisterMessageState;
  factory RegisterState.failure(String message) = RegisterErrorState;
}

class RegisterReadyState extends RegisterState {
  const RegisterReadyState() : super(true);
}

class RegisterWaitingState extends RegisterState {
  const RegisterWaitingState() : super(true);
}

class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState() : super(false);
}

class RegisterMessageState extends RegisterState {
  final String message;
  const RegisterMessageState(this.message) : super(false);
}

class RegisterErrorState extends RegisterState {
  final String message;
  const RegisterErrorState(this.message) : super(false);
}
