import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/password_recovery_screen/password_recovery_cubit.dart';
import 'package:odo24_mobile/presentatin/password_recovery_screen/password_recovery_stepper_widget.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/error_dialog.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановить пароль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => PasswordRecoveryCubit(),
            child: BlocConsumer<PasswordRecoveryCubit, AppState>(
              listener: (context, state) {
                if (state is AppStateError) {
                  showErrorDialog(context, title: 'Восстановление пароля', message: state.error);
                } else if (state is PasswordRecoverySendCodeSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Код отправлен на ${state.email}"),
                  ));
                } else if (state is PasswordRecoverySuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Новый пароль сохранён'),
                  ));
                  Navigator.of(context).pop();
                }
              },
              buildWhen: (previous, current) => current is! PasswordRecoverySendCodeSuccessState,
              builder: (context, state) => const PasswordRecoveryStepperWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
