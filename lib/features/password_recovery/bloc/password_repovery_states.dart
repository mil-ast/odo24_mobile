sealed class PasswordRecoveryState {
  const PasswordRecoveryState();
  factory PasswordRecoveryState.ready() = PasswordRecoveryReadyState;
  factory PasswordRecoveryState.idle() = PasswordRecoveryWaitingState;
  factory PasswordRecoveryState.failure(String message) = PasswordRecoveryErrorState;
  factory PasswordRecoveryState.informMessage(String message) = PasswordRecoveryInformMessageState;
  factory PasswordRecoveryState.success() = PasswordRecoverySuccessState;
}

class PasswordRecoveryReadyState extends PasswordRecoveryState {}

class PasswordRecoveryWaitingState extends PasswordRecoveryState {}

class PasswordRecoverySuccessState extends PasswordRecoveryState {}

class PasswordRecoveryErrorState extends PasswordRecoveryState {
  final String message;
  const PasswordRecoveryErrorState(this.message);
}

class PasswordRecoveryInformMessageState extends PasswordRecoveryState {
  final String message;
  const PasswordRecoveryInformMessageState(this.message);
}
