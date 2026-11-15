import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/bloc/login_cubit.dart';
import 'package:odo24_mobile/features/login/bloc/login_states.dart';
import 'package:odo24_mobile/features/password_recovery/bloc/password_recovery_cubit.dart';
import 'package:odo24_mobile/features/password_recovery/password_recovery_screen.dart';
import 'package:odo24_mobile/features/profile/about/about_screen.dart';
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
  bool _obscurePassword = true;

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
        //title: 'Сервисная книжка автомобиля',
        body: Material(
          color: ODO24LightThemeColors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        const _LoginHeroCard(),
                        _buildLoginForm(context, state),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _openAbout(context),
                            icon: const Icon(Icons.info_outline_rounded, size: 18),
                            label: const Text('О приложении'),
                            style: TextButton.styleFrom(foregroundColor: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    final cubit = context.read<LoginCubit>();

    return FormDialogCard(
      formKey: _formKey,
      icon: Icons.lock_outline_rounded,
      title: 'Вход в аккаунт',
      description: 'Введите e-mail и пароль, чтобы синхронизировать данные.',
      children: [
        TextFormField(
          enabled: !state.isWaiting,
          controller: _loginController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.alternate_email_rounded)),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Логин не указан';
            }
            return null;
          },
        ),
        TextFormField(
          enabled: !state.isWaiting,
          controller: _passwordController,
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Пароль',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscurePassword ? 'Показать пароль' : 'Скрыть пароль',
              onPressed: state.isWaiting
                  ? null
                  : () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    }),
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пароль не указан';
            }
            return null;
          },
          onFieldSubmitted: (_) => _login(context),
        ),
        const Divider(height: 1, color: Color(0xFFEDEFF2)),
        FilledButton.icon(
          onPressed: state.isWaiting ? null : () => _login(context),
          icon: state.isWaiting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.login_rounded),
          label: Text(state.isWaiting ? 'Входим…' : 'Войти'),
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            TextButton(onPressed: state.isWaiting ? null : cubit.onClickRegister, child: const Text('Регистрация')),
            TextButton(
              onPressed: state.isWaiting ? null : cubit.onClickPasswordRecovery,
              child: const Text('Забыли пароль?'),
            ),
          ],
        ),
      ],
    );
  }

  void _openAbout(BuildContext context) {
    Navigator.of(context).push<void>(MaterialPageRoute(builder: (context) => const AboutScreen()));
  }

  void _login(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Укажите e-mail и пароль')));
      return;
    }

    final login = _loginController.text.trim();
    final password = _passwordController.text;
    context.read<LoginCubit>().signInWithEmailAndPassword(login, password);
  }
}

class _LoginHeroCard extends StatelessWidget {
  const _LoginHeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              //SvgPicture.asset('assets/logo_dark.svg', width: 64, height: 64),
              SvgPicture.asset('assets/logo_v2.svg', width: 72, height: 72),
              const SizedBox(height: 14),
              Text(
                'Сервисная книжка автомобиля',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Войдите, чтобы продолжить вести историю обслуживания автомобиля.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
