import 'package:flutter/material.dart';

class PasswordRecoveryNewPasswordScreen extends StatefulWidget {
  const PasswordRecoveryNewPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordRecoveryNewPasswordState();
}

class _PasswordRecoveryNewPasswordState extends State<PasswordRecoveryNewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановить пароль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Придумайте новый пароль'),
      ),
    );
  }
}
