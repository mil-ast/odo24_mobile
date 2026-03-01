import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';
import 'package:odo24_mobile/features/register/register_confirmation_email_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = DependenciesScope.of(context).authService;

    return BlocProvider(
      create: (context) => RegisterCubit(authService: authService),
      child: const RegisterWidget(),
    );
  }
}

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

final class RegisterScreenState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => current.hasError || current.isSuccess || current.isCompeted,
      listener: (context, state) {
        switch (state) {
          case RegisterSuccessState():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Регистрация прошла успешно!'),
                backgroundColor: Theme.of(context).colorScheme.success,
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          case RegisterOpenEmailConfirmationState():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<RegisterCubit>(),
                  child: RegisterConfirmationEmailScreen(
                    email: state.email,
                    password: state.password,
                    buttonTitle: 'Зарегистрировать',
                  ),
                ),
              ),
            );
          case RegisterMessageState():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Theme.of(context).colorScheme.error),
            );
          case RegisterErrorState():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Theme.of(context).colorScheme.error),
            );
          default:
        }
      },
      child: AppScaffold(
        title: 'Регистрация',
        automaticallyImplyLeading: true,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return Column(
                    spacing: 10,
                    children: [
                      AppCard(
                        title: const AppCardTitle(title: 'Шаг 1 / 2'),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            spacing: 40,
                            children: [
                              TextFormField(
                                enabled: !state.isWaiting,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(labelText: 'E-mail'),
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
                                enabled: !state.isWaiting,
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: const InputDecoration(labelText: 'Придумайте пароль'),
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
                                enabled: !state.isWaiting,
                                controller: _confirmPasswordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(labelText: 'Повторите пароль'),
                                validator: (confirmPasswd) {
                                  if (confirmPasswd == null || confirmPasswd.trim().isEmpty) {
                                    return 'Повторите пароль';
                                  } else if (_passwordController.text != confirmPasswd) {
                                    return 'Пароль не совпадает';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: state.isWaiting
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                final email = _emailController.text.trim();
                                final passwd = _passwordController.text.trim();
                                context.read<RegisterCubit>().sendRegisterCode(email, passwd);
                              },
                        child: const Text('Далее'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
