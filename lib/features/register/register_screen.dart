import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
        body: Material(
          color: ODO24LightThemeColors.surfaceMuted,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: BlocBuilder<RegisterCubit, RegisterState>(
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
                        const _RegisterHeroCard(),
                        _buildRegisterForm(context, state),
                        Center(
                          child: TextButton(
                            onPressed: state.isWaiting ? null : () => Navigator.of(context).pop(),
                            child: const Text('Уже есть аккаунт? Войти'),
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

  Widget _buildRegisterForm(BuildContext context, RegisterState state) {
    final enabled = !state.isWaiting;

    return FormDialogCard(
      formKey: _formKey,
      icon: Icons.person_add_alt_1_rounded,
      title: 'Данные для входа',
      description: 'Пароль должен содержать не менее 6 символов.',
      children: [
        TextFormField(
          enabled: enabled,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.alternate_email_rounded)),
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
          enabled: enabled,
          controller: _passwordController,
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Придумайте пароль',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscurePassword ? 'Показать пароль' : 'Скрыть пароль',
              onPressed: enabled
                  ? () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    })
                  : null,
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
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
          enabled: enabled,
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Повторите пароль',
            prefixIcon: const Icon(Icons.lock_reset_rounded),
            suffixIcon: IconButton(
              tooltip: _obscureConfirmPassword ? 'Показать пароль' : 'Скрыть пароль',
              onPressed: enabled
                  ? () => setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    })
                  : null,
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
          validator: (confirmPasswd) {
            if (confirmPasswd == null || confirmPasswd.trim().isEmpty) {
              return 'Повторите пароль';
            } else if (_passwordController.text != confirmPasswd) {
              return 'Пароль не совпадает';
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(context),
        ),
        const Divider(height: 1, color: Color(0xFFEDEFF2)),
        FilledButton.icon(
          onPressed: enabled ? () => _submit(context) : null,
          icon: state.isWaiting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.arrow_forward_rounded),
          label: Text(state.isWaiting ? 'Отправляем…' : 'Далее'),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final passwd = _passwordController.text.trim();
    context.read<RegisterCubit>().sendRegisterCode(email, passwd);
  }
}

class _RegisterHeroCard extends StatelessWidget {
  const _RegisterHeroCard();

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
              SvgPicture.asset('assets/logo_dark.svg', width: 64, height: 64),
              const SizedBox(height: 14),
              Text(
                'Создание аккаунта',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Шаг 1 из 2 — укажите e-mail и придумайте пароль.',
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
