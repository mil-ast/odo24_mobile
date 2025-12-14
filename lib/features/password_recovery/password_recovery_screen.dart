import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';
import 'package:odo24_mobile/features/password_recovery/confirmation_email_form/confirmation_email_screen.dart';
import 'package:odo24_mobile/features/password_recovery/password_recovery_form_widget.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formEmailKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordRecoveryCubit, PasswordRecoveryState>(
      listenWhen: (previous, current) =>
          current.hasError || current.isSuccess || current.isCompeted,
      listener: (context, state) {
        switch (state) {
          case PasswordRecoveryFormCodeSentSuccessfullyState(): // код подтверждения отправлен
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<PasswordRecoveryCubit>(),
                  child: ConfirmationEmailScreen(
                    email: state.email,
                    password: state.password,
                  ),
                ),
              ),
            );
            break;
          case PasswordRecoveryFormSuccessfullState(): // успешно
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Пароль успешно изменён'),
                backgroundColor: Theme.of(context).colorScheme.success,
              ),
            );
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case PasswordRecoveryFailureState():
            final details = state.error.details != null
                ? '\n${state.error.details}'
                : '';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error.message}$details'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            break;
          default:
        }
      },
      child: AppScaffold(
        title: 'Восстановление пароля',
        automaticallyImplyLeading: true,
        body: AppCard(
          title: const AppCardTitle(title: 'Шаг 1 / 2'),
          child: PasswordRecoveryFormWidget(
            formEmailKey: _formEmailKey,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
        ),
        persistentFooterButtons: [
          BlocBuilder<PasswordRecoveryCubit, PasswordRecoveryState>(
            builder: (context, state) {
              return FilledButton.icon(
                onPressed: state.isWaiting
                    ? null
                    : () {
                        if (!(_formEmailKey.currentState?.validate() ??
                            false)) {
                          return;
                        }
                        context.read<PasswordRecoveryCubit>().submitForm(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                label: const Text('Далее'),
                icon: const Icon(Icons.arrow_forward),
                iconAlignment: IconAlignment.end,
              );
            },
          ),
        ],
      ),
    );
  }
}
