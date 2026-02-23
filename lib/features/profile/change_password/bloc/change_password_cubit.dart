import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';

enum ChangePasswordState { ready, successful, error }

class ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  const ChangePasswordEvent({required this.newPassword, required this.oldPassword});
}

class ChangePasswordCubit extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthService _authService;

  ChangePasswordCubit({required AuthService authService})
    : _authService = authService,
      super(ChangePasswordState.ready) {
    on<ChangePasswordEvent>(_onChangePassword);
  }

  void _onChangePassword(ChangePasswordEvent event, emit) async {
    try {
      await _authService.changePassword(event.oldPassword, event.newPassword);
      emit(ChangePasswordState.successful);
    } catch (e) {
      emit(ChangePasswordState.error);
      rethrow;
    }
  }
}
