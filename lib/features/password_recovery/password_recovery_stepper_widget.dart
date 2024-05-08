import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';

class PasswordRecoveryStepperWidget extends StatefulWidget {
  const PasswordRecoveryStepperWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordRecoveryStepperWidgetState();
}

enum StepWidget {
  email,
  newPassword,
  emailConfirm;

  const StepWidget();
}

class _PasswordRecoveryStepperWidgetState extends State<PasswordRecoveryStepperWidget> {
  Timer? _timerCodeButton;
  static const timerDuration = Duration(minutes: 10);
  final _formEmailKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  int _index = StepWidget.email.index;
  bool _sendCodeButtonEnabled = true;

  @override
  void dispose() {
    super.dispose();
    _timerCodeButton?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stepper(
        currentStep: _index,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_index > StepWidget.email.index)
                  FilledButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Назад'),
                  ),
                if (_index < StepWidget.emailConfirm.index)
                  FilledButton(
                    onPressed: () {
                      if (_index == StepWidget.email.index) {
                        if (!_formEmailKey.currentState!.validate()) {
                          return;
                        }
                      } else if (!_formPasswordKey.currentState!.validate()) {
                        return;
                      }
                      _onNext();
                    },
                    child: const Text('Далее'),
                  ),
                if (_index == StepWidget.emailConfirm.index)
                  FilledButton.icon(
                    onPressed: _onComplete,
                    icon: const Icon(Icons.flag),
                    label: const Text('Сохранить'),
                  )
              ],
            ),
          );
        },
        onStepCancel: _onPrev,
        onStepContinue: _onNext,
        onStepTapped: null,
        steps: <Step>[
          Step(
            title: const Text('Укажите ваш адрес электронной почты'),
            subtitle: _emailController.text.isNotEmpty ? Text(_emailController.text) : null,
            content: Form(
              key: _formEmailKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: const InputDecoration(
                  helperText: 'Email',
                ),
                validator: (value) {
                  if (_emailController.text.length < 5) {
                    return 'Введите ваш Email';
                  } else if (!_emailController.text.contains('@')) {
                    return 'Некорректный email';
                  }
                  return null;
                },
              ),
            ),
          ),
          Step(
            title: const Text('Придумайте новый пароль'),
            content: Form(
              key: _formPasswordKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      helperText: "Придумайте пароль",
                    ),
                    validator: (passwd) {
                      if (passwd == null || passwd.isEmpty) {
                        return 'Введите пароль';
                      } else if (passwd.length < 6) {
                        return 'Пароль слишком короткий';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(
                      helperText: "Повторите пароль",
                    ),
                    validator: (String? confirmPasswd) {
                      if (confirmPasswd == null) {
                        return null;
                      }
                      if (confirmPasswd.isEmpty) {
                        return 'Повторите пароль';
                      } else if (_passwordController.text != confirmPasswd) {
                        return 'Пароль не совпадает';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Подтвердите почту'),
            subtitle: _emailController.text.isNotEmpty ? Text(_emailController.text) : null,
            content: Column(
              children: [
                FilledButton.icon(
                  onPressed: _sendCodeButtonEnabled ? _onClickSendCode : null,
                  icon: const Icon(Icons.email),
                  label: Text(_sendCodeButtonEnabled ? 'Отправить код на почту' : 'Код отправлен'),
                ),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        'Для подтверждения почты необходимо отправить на неё проверочный код. После чего вставить код с e-mail в поле ниже.'),
                  ),
                ),
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    helperText: "Код подтверждения",
                  ),
                  validator: context.read<PasswordRecoveryCubit>().validatePin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onClickSendCode() async {
    if (!_formEmailKey.currentState!.validate()) {
      return;
    }

    setState(
      () {
        _sendCodeButtonEnabled = false;
      },
    );

    final isOk = await context.read<PasswordRecoveryCubit>().recoverSendEmailCodeConfirmation(_emailController.text);
    if (isOk) {
      setState(
        () {
          _timerCodeButton ??= Timer(
            timerDuration,
            _timerHandler,
          );
          _sendCodeButtonEnabled = true;
        },
      );
    }
  }

  void _timerHandler() {
    setState(() {
      _sendCodeButtonEnabled = true;
      _timerCodeButton = null;
    });
  }

  void _onNext() {
    if (_index < StepWidget.emailConfirm.index) {
      setState(() {
        _index += 1;
      });
    }
  }

  void _onPrev() {
    if (_index > 0) {
      setState(() {
        _index -= 1;
      });
    }
  }

  void _onComplete() {
    if (!_formPasswordKey.currentState!.validate()) {
      return;
    }
    final email = _emailController.text;
    final code = int.parse(_pinController.text);
    final password = _passwordController.text;
    context.read<PasswordRecoveryCubit>().saveNewPassword(email, code, password);
  }
}
