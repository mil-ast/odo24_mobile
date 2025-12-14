import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/bloc/login_cubit.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController loginController;
  final TextEditingController passwordController;

  const LoginFormWidget({
    required this.formKey,
    required this.loginController,
    required this.passwordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themePreferences = DependenciesScope.of(context).themePreferences;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 20,
        children: [
          Center(
            child: SvgPicture.asset(
              themePreferences.brightness.value == Brightness.dark
                  ? 'assets/logo.svg'
                  : 'assets/logo_dark.svg',
              width: 80,
              height: 80,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Логин'),
                  controller: loginController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Логин не указан';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Пароль'),
                  controller: passwordController,
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
                      onPressed: context
                          .read<LoginCubit>()
                          .onClickPasswordRecovery,
                      child: const Wrap(children: [Text('Забыли пароль?')]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
