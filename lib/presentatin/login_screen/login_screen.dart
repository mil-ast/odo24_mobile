import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_cubit.dart';
import 'package:odo24_mobile/presentatin/password_recovery_screen/password_recovery_screen.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Сервисная книжка авто'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocProvider(
              create: (context) => LoginCubit(),
              child: BlocConsumer<LoginCubit, AppState>(
                listener: (BuildContext context, AppState state) {
                  if (state is LoginCubitLoginSuccessState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } else if (state is LoginCubitOnClickRegisterState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  } else if (state is LoginCubitOnClickPasswordRecoveryState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen()),
                    );
                  } else if (state is AppStateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is LoginCubitLoginSuccessState || current is AppStateDefault || current is AppStateLoading,
                builder: (BuildContext context, AppState state) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            'assets/logo.svg',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Логин",
                                ),
                                controller: _loginController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Логин не указан';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Пароль",
                                ),
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пароль не указан';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: context.read<LoginCubit>().onClickRegister,
                                    child: const Text('Регистрация'),
                                  ),
                                  TextButton(
                                    onPressed: context.read<LoginCubit>().onClickPasswordRecovery,
                                    child: const Wrap(
                                      children: [Text('Забыли пароль?')],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: state is! AppStateLoading
                                          ? () {
                                              _onLogin(context);
                                            }
                                          : null,
                                      child: const Text('Войти'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }

  void _onLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверный логин или пароль')),
      );
      return;
    }

    final login = _loginController.text;
    final password = _passwordController.text;

    context.read<LoginCubit>().signInWithEmailAndPassword(login, password);
  }
}
