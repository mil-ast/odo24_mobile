import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;
  final String password;

  const EmailConfirmationScreen({
    required this.email,
    required this.password,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _sendCodeButtonEnabled = true;
  bool _registerButtonEnabled = true;

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
                        text: widget.email,
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
                    onPressed: _sendCodeButtonEnabled
                        ? () async {
                            setState(() {
                              _sendCodeButtonEnabled = false;
                            });
                            await context.read<RegisterCubit>().sendRegisterCode(widget.email);
                            setState(() {
                              _sendCodeButtonEnabled = true;
                            });
                          }
                        : null,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        const Icon(Icons.email_outlined),
                        _sendCodeButtonEnabled ? const Text('Отправить код') : const Text('Отправка...'),
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
                    if (code == null) {
                      return 'Введите код из e-mail';
                    }

                    final codeValue = int.tryParse(code);
                    if (codeValue == null) {
                      return 'Некорректный код';
                    } else if (codeValue < 1000) {
                      return 'Слишком короткий';
                    } else if (codeValue > 0xFFFF) {
                      return 'Слишком большой';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Center(
                  child: FilledButton(
                    onPressed: _registerButtonEnabled
                        ? () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            setState(() {
                              _registerButtonEnabled = false;
                            });
                            final code = _codeController.text.trim();
                            await context.read<RegisterCubit>().register(widget.email, widget.password, code);
                            setState(() {
                              _registerButtonEnabled = true;
                            });
                          }
                        : null,
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
