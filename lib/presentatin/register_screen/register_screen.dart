import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

final class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => RegisterCubit(),
            child: BlocConsumer<RegisterCubit, AppState>(
              listener: (context, state) {
                if (state is RegisterCubitRegisterSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Регистрация прошла успешно!'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );

                  Navigator.pushReplacementNamed(
                    context,
                    '/login',
                  );
                } else if (state is RegisterCubitSendCodeSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Код подтверждения отправлен'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (state is AppStateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              buildWhen: (previous, current) => current is AppStateDefault || current is AppStateLoading,
              builder: (context, state) => Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Регистрация',
                      style: TextStyle(fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      decoration: const InputDecoration(
                        helperText: 'Email',
                      ),
                      validator: context.read<RegisterCubit>().validateEmail,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        helperText: "Придумайте пароль",
                      ),
                      validator: context.read<RegisterCubit>().validatePassword,
                    ),
                    TextFormField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        helperText: "Повторите пароль",
                      ),
                      validator: (value) =>
                          context.read<RegisterCubit>().validateConfirmPassword(_passwordController.text, value),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              helperText: "Код подтверждения",
                            ),
                            validator: (value) => context.read<RegisterCubit>().validateCode(_codeController.text),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            if (_emailController.text.isNotEmpty) {
                              context.read<RegisterCubit>().sendRegisterCode(_emailController.text);
                            }
                          },
                          child: const Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(Icons.email_outlined),
                              Text('Отправить код'),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child:
                            Text('На указанный e-mail придёт код подтверждения. Введите его и завершите регистрацию.'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        final login = _emailController.text;
                        final password = _passwordController.text;
                        final code = _codeController.text;

                        context.read<RegisterCubit>().register(login, password, code);
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
