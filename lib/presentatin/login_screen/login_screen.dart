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
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                  if (current is LoginCubitLoginSuccessState) {
                    return false;
                  }
                  return true;
                },
                builder: (BuildContext context, AppState state) {
                  return Card(
                    child: Column(
                      children: [
                        Center(
                          child: Text('Введите логин (e-mail) и пароль'),
                        ),
                        SizedBox(height: 60),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  helperText: "Логин",
                                  icon: Icon(Icons.email_outlined),
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
                              TextFormField(
                                decoration: const InputDecoration(
                                  helperText: "Пароль",
                                  icon: Icon(Icons.password_rounded),
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
                              ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Неверный логин или пароль')),
                                    );
                                  }

                                  final login = _loginController.text;
                                  final password = _passwordController.text;

                                  context.read<LoginCubit>().signInWithEmailAndPassword(login, password);
                                },
                                child: const Text('Войти'),
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

  Widget _buildLoginForm(BuildContext context, AppState state) {
    if (state is AppStateLoading) {
      return const Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(16)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            side: MaterialStateProperty.all(
              BorderSide(width: 1.0, color: Color.fromRGBO(221, 75, 57, 1)),
            ),
          ),
          onPressed: () {
            //context.read<LoginCubit>().signInWithGoogle();
          },
          child: Row(
            children: [
              Image.asset('assets/icons/google.png'),
              const SizedBox(width: 26),
              const Text(
                'GOOGLE',
                style: TextStyle(
                  color: Color.fromRGBO(221, 75, 57, 1),
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
