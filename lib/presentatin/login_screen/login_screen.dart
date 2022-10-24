import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_screen.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  controller: _loginController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
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
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                    }

                    final login = _loginController.text;
                    final password = _passwordController.text;
                    try {
                      await _authService.signInWithEmailAndPassword(
                        login,
                        password,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } on FirebaseException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Неправильный логин или пароль'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Произошла внутренняя ошибка'),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  child: const Text('Войти'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Регистрация'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*return WillPopScope(
      onWillPop: () async => false,
      child: ,
    );
  }*/
}
