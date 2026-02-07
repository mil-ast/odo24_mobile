part of 'password_recovery_cubit.dart';

sealed class PasswordRecoveryState {
  const PasswordRecoveryState();

  const factory PasswordRecoveryState.ready() = PasswordRecoveryReadyState;
  const factory PasswordRecoveryState.waiting() = PasswordRecoveryWaitingState;

  const factory PasswordRecoveryState.codeSentSuccessfully({required String email, required String password}) =
      PasswordRecoveryFormCodeSentSuccessfullyState;

  const factory PasswordRecoveryState.successfully() = PasswordRecoveryFormSuccessfullState;

  const factory PasswordRecoveryState.failure(AppException error) = PasswordRecoveryFailureState;

  bool get isReady => this is PasswordRecoveryReadyState;
  bool get isWaiting => this is PasswordRecoveryWaitingState;
  bool get isSuccess => this is PasswordRecoveryFormCodeSentSuccessfullyState;
  bool get isCompeted => this is PasswordRecoveryFormSuccessfullState;
  bool get hasError => this is PasswordRecoveryFailureState;
}

final class PasswordRecoveryReadyState extends PasswordRecoveryState {
  const PasswordRecoveryReadyState();
}

// код подтверждения успешно отправлен
final class PasswordRecoveryFormCodeSentSuccessfullyState extends PasswordRecoveryState {
  final String email;
  final String password;
  const PasswordRecoveryFormCodeSentSuccessfullyState({required this.email, required this.password});
}

// восстановление пароля успешно
final class PasswordRecoveryFormSuccessfullState extends PasswordRecoveryState {
  const PasswordRecoveryFormSuccessfullState();
}

final class PasswordRecoveryWaitingState extends PasswordRecoveryState {
  const PasswordRecoveryWaitingState();
}

final class PasswordRecoveryFailureState extends PasswordRecoveryState {
  final AppException error;

  const PasswordRecoveryFailureState(this.error);
}
