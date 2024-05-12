import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';

enum ChangePasswordState {
  ready,
  successful,
  error,
}

class ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  const ChangePasswordEvent({
    required this.newPassword,
    required this.oldPassword,
  });
}

class ChangePasswordCubit extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final IAuthRepository _authRepository;

  ChangePasswordCubit({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(ChangePasswordState.ready) {
    on<ChangePasswordEvent>(_onChangePassword);
  }

  void _onChangePassword(ChangePasswordEvent event, emit) async {
    try {
      await _authRepository.changePassword(event.oldPassword, event.newPassword);
      emit(ChangePasswordState.successful);
    } catch (e) {
      emit(ChangePasswordState.error);
      rethrow;
    }
  }
}
