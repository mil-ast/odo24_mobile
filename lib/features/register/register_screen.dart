import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';
import 'package:odo24_mobile/features/register/bloc/register_states.dart';

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
    final authProvider = DependenciesScope.of(context).authRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => RegisterCubit(authRepository: authProvider),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Регистрация прошла успешно!'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                } else if (state is RegisterMessageState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (state is RegisterErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
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
                      validator: (confirmPasswd) {
                        if (confirmPasswd == null || confirmPasswd.isEmpty) {
                          return 'Повторите пароль';
                        } else if (_passwordController.text != confirmPasswd) {
                          return 'Пароль не совпадает';
                        }
                        return null;
                      },
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
                            validator: (code) {
                              if (code == null || code.isEmpty) {
                                return 'Введите код из e-mail';
                              } else if (code.length < 4) {
                                return 'Слишком короткий';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => onSendRegisterCode(context),
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
                      onPressed: state is! RegisterWaitingState ? () => onRegister(context) : null,
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

  void onSendRegisterCode(BuildContext context) {
    if (_emailController.text.isNotEmpty) {
      context.read<RegisterCubit>().sendRegisterCode(_emailController.text);
    }
  }

  void onRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final login = _emailController.text;
    final password = _passwordController.text;
    final code = _codeController.text;

    context.read<RegisterCubit>().register(login, password, code);
  }
}
