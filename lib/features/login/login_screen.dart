import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/bloc/login_cubit.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';
import 'package:odo24_mobile/features/password_recovery/password_recovery_screen.dart';
import 'package:odo24_mobile/features/register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    final authService = dependencies.authService;
    final sp = dependencies.sharedPreferences;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit(authService: authService)),
        BlocProvider(
          create: (context) => PasswordRecoveryCubit(authService: authService, sharedPreferences: sp),
        ),
      ],
      child: const LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginSuccessState():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Успешно авторизовались'),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).colorScheme.success,
              ),
            );
          case LoginGoToRegisterState():
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
          case LoginGoToPasswordRecoveryState():
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<PasswordRecoveryCubit>(),
                  child: const PasswordRecoveryScreen(),
                ),
              ),
            );
          case LoginErrorState():
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Theme.of(context).colorScheme.error),
            );
          default:
        }
      },
      child: AppScaffold(
        title: 'Сервисная книжка автомобиля',
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final themePreferences = DependenciesScope.of(context).themePreferences;
                  return Column(
                    spacing: 10,
                    children: [
                      AppCard(
                        title: const AppCardTitle(title: 'Авторизация'),
                        child: Center(
                          child: Column(
                            spacing: 20,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  themePreferences.brightness.value == Brightness.dark
                                      ? 'assets/logo.svg'
                                      : 'assets/logo_dark.svg',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  spacing: 20,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      enabled: !state.isWaiting,
                                      decoration: const InputDecoration(hintText: 'E-mail'),
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
                                      enabled: !state.isWaiting,
                                      decoration: const InputDecoration(hintText: 'Пароль'),
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
                                          child: const Wrap(children: [Text('Забыли пароль?')]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        icon: const Icon(Icons.login_outlined),
                        onPressed: state.isWaiting ? null : () => _onLogin(context),
                        label: const Text('Войти'),
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

  void _onLogin(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверный логин или пароль')));
      return;
    }

    final login = _loginController.text;
    final password = _passwordController.text;
    context.read<LoginCubit>().signInWithEmailAndPassword(login, password);
  }
}
