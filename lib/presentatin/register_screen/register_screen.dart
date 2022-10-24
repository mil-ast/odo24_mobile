import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: const InputDecoration(
                    helperText: 'Email',
                    icon: Icon(Icons.email_outlined),
                  ),
                  validator: (String? email) {
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
                    helperText: "Пароль",
                    icon: Icon(Icons.vpn_key),
                  ),
                  validator: (String? passwd) {
                    if (passwd == null || passwd.isEmpty) {
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
                  decoration: const InputDecoration(
                    helperText: "Повторите пароль",
                    icon: Icon(Icons.vpn_key),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Повторите пароль';
                    } else if (_passwordConfirmController.text != value) {
                      return 'Пароль не совпадает';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                    }

                    try {
                      final login = _emailController.text;
                      final password = _passwordController.text;
                      final result = await _authService.createUserWithEmailAndPassword(
                        login,
                        password,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Регистрация прошла успешно!'),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } on FirebaseException catch (e) {
                      String errorMessage;

                      switch (e.code) {
                        case 'email-already-in-use':
                          errorMessage = 'Email уже занят';
                          break;
                        default:
                          errorMessage = e.message ?? e.code;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Неправильный логин или пароль'),
                        ),
                      );
                    }
                  },
                  child: const Text('Зарегистрироваться'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Авторизация'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
