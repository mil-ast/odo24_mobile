import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';

class EmailConfirmationScreen extends StatelessWidget {
  EmailConfirmationScreen({
    required this.email,
    required this.password,
    super.key,
  });

  final String email;
  final String password;

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация: подтверждение почты'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Для завершения регистрации необходимо подтвердить ваш Email ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                        text: email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Для этого отправьте проверочный код на почту и далее введите его в поле ниже.'),
                const SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<RegisterCubit>().sendRegisterCode(email);
                    },
                    child: const Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.email_outlined),
                        Text('Отправить код'),
                      ],
                    ),
                  ),
                ),
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    helperText: "Код подтверждения",
                  ),
                  validator: (code) {
                    if (code == null || code.trim().isEmpty) {
                      return 'Введите код из e-mail';
                    } else if (code.length < 4) {
                      return 'Слишком короткий';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Center(
                  child: FilledButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final code = _codeController.text.trim();
                      context.read<RegisterCubit>().register(email, password, code);
                    },
                    child: const Text('Завершить'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
