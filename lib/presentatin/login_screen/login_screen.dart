import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_cubit.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

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
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, AppState>(
              listener: (BuildContext context, AppState state) {
                if (state is LoginCubitLoginSuccessState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else if (state is LoginCubitOnClickRegisterState) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
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
                if (current is LoginCubitLoginSuccessState || current is LoginCubitOnClickRegisterState) {
                  return false;
                }

                return true;
              },
              builder: (BuildContext context, AppState state) {
                return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _loginController,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          helperText: 'Email',
                          icon: Icon(Icons.email_outlined),
                        ),
                        validator: context.read<LoginCubit>().validateEmail,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          helperText: "Пароль",
                          icon: Icon(Icons.vpn_key),
                        ),
                        validator: context.read<LoginCubit>().validatePassword,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          context.read<LoginCubit>().login(_loginController.text, _passwordController.text);
                        },
                        child: const Text('Войти'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: context.read<LoginCubit>().onClickRegister,
                        child: Text('Регистрация'),
                      )
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
