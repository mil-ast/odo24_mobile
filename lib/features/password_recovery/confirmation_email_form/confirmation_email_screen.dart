import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';

class ConfirmationEmailScreen extends StatefulWidget {
  final String _email;
  final String _password;

  const ConfirmationEmailScreen({
    required String email,
    required String password,
    super.key,
  })  : _email = email,
        _password = password;

  @override
  State<ConfirmationEmailScreen> createState() =>
      _ConfirmationEmailScreenState();
}

class _ConfirmationEmailScreenState extends State<ConfirmationEmailScreen> {
  final _codeConfirmationController = TextEditingController();

  @override
  void dispose() {
    _codeConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
      listener: (context, state) {
        switch (state) {
          case PasswordRecoveryFormSuccessfullState():
          case PasswordRecoveryWaitingState():
            setState(() {});
          default:
            setState(() {});
        }
      },
      builder: (context, state) {
        return AppScaffold(
          title: 'Подтверждение E-mail',
          body: AppCard(
            title: const AppCardTitle(title: 'Шаг 2 / 2'),
            child: Column(
              spacing: 10,
              children: [
                Text(
                    'На почту ${widget._email} был отправлен код подтверждения.'),
                const Text('Введите его в поле ниже для подтвеждения почты.'),
                const SizedBox(height: 20),
                TextFormField(
                  enabled: !state.isWaiting,
                  controller: _codeConfirmationController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Код подтверждения',
                  ),
                  validator: (pin) {
                    if (pin == null || pin.isEmpty) {
                      return 'Введите проверочный код';
                    } else if (pin.length < 3) {
                      return 'Неверный код';
                    }
                    final code = int.tryParse(pin);
                    if (code == null) {
                      return 'Неверный код';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          persistentFooterButtons: [
            FilledButton.icon(
              onPressed: state.isWaiting
                  ? null
                  : () {
                      if (_codeConfirmationController.text.length < 3 ||
                          _codeConfirmationController.text.length > 10) {
                        return;
                      }

                      final code =
                          int.tryParse(_codeConfirmationController.text);
                      if (code == null) {
                        return;
                      }

                      context.read<PasswordRecoveryCubit>().recovery(
                            email: widget._email,
                            password: widget._password,
                            code: code,
                          );
                    },
              label: const Text('Сохранить'),
              icon: const Icon(Icons.done),
              iconAlignment: IconAlignment.end,
            )
          ],
        );
      },
    );
  }
}
