import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_repovery_states.dart';
import 'package:odo24_mobile/features/password_recovery/password_recovery_stepper_widget.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = DependenciesScope.of(context).authRepository;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановить пароль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => PasswordRecoveryCubit(authRepository: authProvider),
            child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
              listener: (context, state) {
                if (state is PasswordRecoveryErrorState) {
                  showErrorDialog(context, title: 'Восстановление пароля', message: state.message);
                } else if (state is PasswordRecoveryInformMessageState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                } else if (state is PasswordRecoverySuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Новый пароль сохранён'),
                  ));
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (previous, current) =>
                  current is PasswordRecoveryReadyState || current is PasswordRecoveryWaitingState,
              builder: (context, state) => const PasswordRecoveryStepperWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
