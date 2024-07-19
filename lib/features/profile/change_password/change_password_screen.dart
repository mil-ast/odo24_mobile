import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/profile/change_password/bloc/change_password_cubit.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = DependenciesScope.of(context).authRepository;
    return BlocProvider(
      create: (context) => ChangePasswordCubit(authRepository: authRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Изменить пароль'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Builder(builder: (context) {
              return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
                  switch (state) {
                    case ChangePasswordState.error:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Произошла ошибка при изменении пароля'),
                        ),
                      );
                    case ChangePasswordState.successful:
                      _formKey.currentState!.reset();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Пароль успешно изменён!'),
                        ),
                      );

                      Navigator.pop(context);
                    default:
                  }
                },
                buildWhen: (previous, current) => current == ChangePasswordState.ready,
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          autofocus: true,
                          decoration: const InputDecoration(
                            helperText: 'Текущий пароль',
                          ),
                          validator: _passwordValidate,
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            helperText: 'Придумайте новый пароль',
                          ),
                          validator: _passwordValidate,
                        ),
                        TextFormField(
                          controller: _newPasswordConfirmController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            helperText: 'Подтвердите новый пароль',
                          ),
                          validator: (String? passwd) {
                            if (passwd != null && passwd.isNotEmpty) {
                              if (passwd != _newPasswordController.text) {
                                return 'Пароли не совпадают!';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              context.read<ChangePasswordCubit>().add(
                                    ChangePasswordEvent(
                                      newPassword: _newPasswordController.text,
                                      oldPassword: _oldPasswordController.text,
                                    ),
                                  );
                            },
                            child: const Text('Сохранить'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  String? _passwordValidate(String? passwd) {
    if (passwd == null || passwd.isEmpty) {
      return null;
    }
    if (passwd.isEmpty) {
      return 'Введите пароль';
    } else if (passwd.length < 6) {
      return 'Пароль слишком короткий';
    }
    return null;
  }
}
