import 'package:flutter/material.dart';

class PasswordRecoveryFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formEmailKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const PasswordRecoveryFormWidget({
    required this.formEmailKey,
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  @override
  State<PasswordRecoveryFormWidget> createState() => _PasswordRecoveryFormWidgetState();
}

class _PasswordRecoveryFormWidgetState extends State<PasswordRecoveryFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formEmailKey,
      child: Column(
        spacing: 40,
        children: [
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (value) {
              if (widget.emailController.text.length < 5) {
                return 'Введите ваш Email';
              } else if (!widget.emailController.text.contains('@')) {
                return 'Некорректный email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget.passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(labelText: 'Введите новый пароль'),
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
            keyboardType: TextInputType.text,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(labelText: 'Повторите пароль'),
            validator: (confirmPasswd) {
              if (confirmPasswd == null) {
                return null;
              }
              if (confirmPasswd.isEmpty) {
                return 'Повторите пароль';
              } else if (widget.passwordController.text != confirmPasswd) {
                return 'Пароль не совпадает';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
