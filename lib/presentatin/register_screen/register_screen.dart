import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Сервисная книжка авто'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => RegisterCubit(),
              child: BlocConsumer<RegisterCubit, AppState>(
                listener: (context, state) {
                  if (state is RegisterCubitRegisterSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Регистрация прошла успешно!'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else if (state is AppStateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) {
                  if (current is RegisterCubitRegisterSuccessState || current is AppStateError) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) => Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          decoration: const InputDecoration(
                            helperText: 'Email',
                            icon: Icon(Icons.email_outlined),
                          ),
                          validator: context.read<RegisterCubit>().validateEmail),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          helperText: "Пароль",
                          icon: Icon(Icons.vpn_key),
                        ),
                        validator: context.read<RegisterCubit>().validatePassword,
                      ),
                      TextFormField(
                        controller: _passwordConfirmController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          helperText: "Повторите пароль",
                          icon: Icon(Icons.vpn_key),
                        ),
                        validator: (value) =>
                            context.read<RegisterCubit>().validateConfirmPassword(_passwordController.text, value),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final login = _emailController.text;
                          final password = _passwordController.text;

                          context.read<RegisterCubit>().register(login, password);
                        },
                        child: const Text('Зарегистрироваться'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Авторизация'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
