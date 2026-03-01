import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';

class PasswordRecoveryConfirmationEmailScreen extends StatefulWidget {
  final String _email;
  final String _password;
  const PasswordRecoveryConfirmationEmailScreen({
    required String email,
    required String password,
    String? buttonTitle,
    super.key,
  }) : _email = email,
       _password = password;

  @override
  State<PasswordRecoveryConfirmationEmailScreen> createState() => _RegisterConfirmationEmailScreenState();
}

class _RegisterConfirmationEmailScreenState extends State<PasswordRecoveryConfirmationEmailScreen> {
  final _codeConfirmationController = TextEditingController();
  @override
  void dispose() {
    _codeConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Подтверждение E-mail',
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: BlocBuilder<PasswordRecoveryCubit, PasswordRecoveryState>(
              builder: (context, state) {
                final enabled = !state.isWaiting;
                return Column(
                  spacing: 10,
                  children: [
                    AppCard(
                      title: const AppCardTitle(title: 'Шаг 2 / 2'),
                      child: Column(
                        spacing: 10,
                        children: [
                          Text('На почту ${widget._email} был отправлен код подтверждения.'),
                          const Text('Введите его в поле ниже для подтвеждения почты.'),
                          const SizedBox(height: 20),
                          TextFormField(
                            enabled: enabled,
                            controller: _codeConfirmationController,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration: const InputDecoration(labelText: 'Код подтверждения'),
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
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: enabled
                          ? () {
                              if (_codeConfirmationController.text.length < 3 ||
                                  _codeConfirmationController.text.length > 10) {
                                return;
                              }
                              final code = int.tryParse(_codeConfirmationController.text);
                              if (code == null) {
                                return;
                              }

                              context.read<PasswordRecoveryCubit>().recovery(
                                email: widget._email,
                                password: widget._password,
                                code: code,
                              );
                            }
                          : null,
                      label: const Text('Сохранить'),
                      icon: const Icon(Icons.done),
                      iconAlignment: IconAlignment.end,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
