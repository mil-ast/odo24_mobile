import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/cars/cars_screen.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/bloc/login_cubit.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';
import 'package:odo24_mobile/features/login/login_form_widget.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';
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
    final dependencies = DependenciesScope.of(context);
    final authRepository = dependencies.authRepository;
    final sp = dependencies.sharedPreferences;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(authRepository: authRepository),
        ),
        BlocProvider(
          create: (context) => PasswordRecoveryCubit(
            authRepository: authRepository,
            sharedPreferences: sp,
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AppScaffold(
              automaticallyImplyLeading: true,
              body: AppCard(
                title: const AppCardTitle(title: 'Сервисная книжка автомобиля'),
                child: Center(
                  child: BlocListener<LoginCubit, LoginState>(
                    listener: (BuildContext context, LoginState state) {
                      switch (state) {
                        case LoginSuccessState():
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CarsScreen(),
                            ),
                          );
                        case LoginGoToRegisterState():
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
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
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                          );
                        default:
                      }
                    },
                    child: LoginFormWidget(
                      formKey: _formKey,
                      loginController: _loginController,
                      passwordController: _passwordController,
                    ),
                  ),
                ),
              ),
              persistentFooterButtons: [
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, state) =>
                      state.isWaiting || state.isReady,
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: state is LoginWaitingState
                          ? null
                          : () => _onLogin(context),
                      child: const Text('Войти'),
                    );
                  },
                ),
              ],
            ),
          );
        },
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
