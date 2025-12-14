import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/register/bloc/register_cubit.dart';
import 'package:odo24_mobile/features/register/bloc/register_states.dart';
import 'package:odo24_mobile/features/register/register_form_widget.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = DependenciesScope.of(context).authRepository;

    return BlocProvider(
      create: (context) => RegisterCubit(authRepository: authProvider),
      child: Builder(
        builder: (context) => BlocConsumer<RegisterCubit, RegisterState>(
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
          builder: (context, state) => AppScaffold(
            title: 'Регистрация',
            automaticallyImplyLeading: true,
            body: AppCard(
              title: const AppCardTitle(title: 'Шаг 1 / 2'),
              child: RegisterFormWidget(
                formEmailKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
            persistentFooterButtons: [
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  final email = _emailController.text.trim();
                  final passwd = _passwordController.text.trim();
                  context.read<RegisterCubit>().openEmailConfirmationScreen(
                    email,
                    passwd,
                  );
                },
                child: const Text('Далее'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
