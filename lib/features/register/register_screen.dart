import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';
import 'package:odo24_mobile/features/register/bloc/register_states.dart';
import 'package:odo24_mobile/features/register/widgets/email_confirmation/email_confirmation_screen.dart';

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
              listenWhen: (previous, current) => !current.isBuild,
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
                } else if (state is RegisterOpenEmailConfirmationState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<RegisterCubit>(),
                        child: EmailConfirmationScreen(
                          email: state.email,
                          password: state.password,
                        ),
                      ),
                    ),
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
              buildWhen: (previous, current) => current.isBuild,
              builder: (context, state) => Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        helperText: 'Придумайте пароль',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (passwd) {
                        if (passwd == null || passwd.trim().isEmpty) {
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        helperText: 'Повторите пароль',
                      ),
                      validator: (confirmPasswd) {
                        if (confirmPasswd == null || confirmPasswd.trim().isEmpty) {
                          return 'Повторите пароль';
                        } else if (_passwordController.text != confirmPasswd) {
                          return 'Пароль не совпадает';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final email = _emailController.text.trim();
                        final passwd = _passwordController.text.trim();
                        context.read<RegisterCubit>().openEmailConfirmationScreen(email, passwd);
                      },
                      child: const Text('Далее'),
                    ),
                    const SizedBox(height: 10),
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
