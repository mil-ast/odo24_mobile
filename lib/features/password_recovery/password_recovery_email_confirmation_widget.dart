import 'package:flutter/material.dart';

class PasswordRecoveryEmailConfirmationWidget extends StatefulWidget {
  final String email;
  final TextEditingController confirmationCodeController;
  const PasswordRecoveryEmailConfirmationWidget({
    required this.email,
    required this.confirmationCodeController,
    super.key,
  });

  @override
  State<PasswordRecoveryEmailConfirmationWidget> createState() => _PasswordRecoveryEmailConfirmationWidgetState();
}

class _PasswordRecoveryEmailConfirmationWidgetState extends State<PasswordRecoveryEmailConfirmationWidget> {
  final _formEmailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formEmailKey,
      child: Column(
        spacing: 40,
        children: [
          Column(
            children: [
              const Text('Код был отправлен на почту'),
              Text(widget.email, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          TextFormField(
            controller: widget.confirmationCodeController,
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
    );
  }
}
