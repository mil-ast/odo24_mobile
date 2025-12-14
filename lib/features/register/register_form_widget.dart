import 'package:flutter/material.dart';

class RegisterFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formEmailKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterFormWidget({
    required this.formEmailKey,
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _passwordConfirmController.dispose();
    super.dispose();
  }

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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'E-mail'),
            validator: (email) {
              if (email == null || email.length < 5) {
                return 'Введите ваш Email';
              } else if (!email.contains('@')) {
                return 'Некорректный email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget.passwordController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(labelText: 'Придумайте пароль'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (passwd) {
              if (passwd == null || passwd.trim().isEmpty) {
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(labelText: 'Повторите пароль'),
            validator: (confirmPasswd) {
              if (confirmPasswd == null || confirmPasswd.trim().isEmpty) {
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
