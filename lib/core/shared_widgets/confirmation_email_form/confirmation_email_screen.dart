import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';

class ConfirmationEmailScreen extends StatefulWidget {
  final String _email;
  final String _password;
  final String? _buttonTitle;
  final Future<void> Function({required String email, required String password, required int code}) _onSubmit;

  const ConfirmationEmailScreen({
    required String email,
    required String password,
    String? buttonTitle,
    required Future<void> Function({required String email, required String password, required int code}) onSubmit,
    super.key,
  }) : _email = email,
       _password = password,
       _onSubmit = onSubmit,
       _buttonTitle = buttonTitle;

  @override
  State<ConfirmationEmailScreen> createState() => _ConfirmationEmailScreenState();
}

class _ConfirmationEmailScreenState extends State<ConfirmationEmailScreen> {
  final _codeConfirmationController = TextEditingController();
  bool isWaiting = false;

  @override
  void dispose() {
    _codeConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Подтверждение E-mail',
      body: AppCard(
        title: const AppCardTitle(title: 'Шаг 2 / 2'),
        child: Column(
          spacing: 10,
          children: [
            Text('На почту ${widget._email} был отправлен код подтверждения.'),
            const Text('Введите его в поле ниже для подтвеждения почты.'),
            const SizedBox(height: 20),
            TextFormField(
              enabled: !isWaiting,
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
      persistentFooterButtons: [
        FilledButton.icon(
          onPressed: isWaiting
              ? null
              : () async {
                  if (_codeConfirmationController.text.length < 3 || _codeConfirmationController.text.length > 10) {
                    return;
                  }

                  final code = int.tryParse(_codeConfirmationController.text);
                  if (code == null) {
                    return;
                  }

                  setState(() {
                    isWaiting = true;
                  });

                  try {
                    await widget._onSubmit(email: widget._email, password: widget._password, code: code);
                  } catch (e) {
                    setState(() {
                      isWaiting = false;
                    });
                  }
                },
          label: Text(widget._buttonTitle ?? 'Сохранить'),
          icon: const Icon(Icons.done),
          iconAlignment: IconAlignment.end,
        ),
      ],
    );
  }
}
