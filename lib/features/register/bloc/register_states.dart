sealed class RegisterState {
  final bool isBuild;
  const RegisterState(this.isBuild);
  factory RegisterState.ready() = RegisterReadyState;
  factory RegisterState.waiting() = RegisterWaitingState;
  factory RegisterState.openEmailConfirmation(String email, String password) = RegisterOpenEmailConfirmationState;
  factory RegisterState.success() = RegisterSuccessState;
  factory RegisterState.message(String message) = RegisterMessageState;
  factory RegisterState.failure(Object message) => RegisterErrorState(message.toString());
}

class RegisterReadyState extends RegisterState {
  const RegisterReadyState() : super(true);
}

class RegisterWaitingState extends RegisterState {
  const RegisterWaitingState() : super(true);
}

class RegisterOpenEmailConfirmationState extends RegisterState {
  final String email;
  final String password;
  const RegisterOpenEmailConfirmationState(this.email, this.password) : super(false);
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
