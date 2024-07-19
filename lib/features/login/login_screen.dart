import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/features/cars/cars_screen.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/bloc/login_cubit.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';
import 'package:odo24_mobile/features/password_recovery/password_recovery_screen.dart';
import 'package:odo24_mobile/features/register/register_screen.dart';

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
    final authRepository = DependenciesScope.of(context).authRepository;
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
              create: (ctx) => LoginCubit(
                authRepository: authRepository,
              ),
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (BuildContext context, LoginState state) {
                  if (state is LoginSuccessState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CarsScreen()),
                    );
                  } else if (state is LoginGoToRegisterState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  } else if (state is LoginGoToPasswordRecoveryState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen()),
                    );
                  } else if (state is LoginErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
                buildWhen: (previous, state) => state is LoginWaitingState || state is LoginReadyState,
                builder: (BuildContext context, LoginState state) {
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
                                  hintText: 'Логин',
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
                                  hintText: 'Пароль',
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
                                      onPressed: state is LoginWaitingState
                                          ? null
                                          : () {
                                              _onLogin(context);
                                            },
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
