import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/password_recovery_screen/password_recovery_cubit.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Восстановить пароль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => PasswordRecoveryCubit(),
            child: BlocConsumer<PasswordRecoveryCubit, AppState>(
              listener: (context, state) {},
              buildWhen: (previous, current) => current is! AppStateError,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Укажите ваш адрес электронной почты',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: const InputDecoration(
                          helperText: 'Email',
                        ),
                        validator: context.read<PasswordRecoveryCubit>().validateEmail,
                      ),
                      const SizedBox(width: 10),
                      Center(
                        child: FilledButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            context
                                .read<PasswordRecoveryCubit>()
                                .recoverSendEmailCodeConfirmation(_emailController.text);
                          },
                          child: const Text('Отправить'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
