import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/password_recovery_screen/password_recovery_screen.dart';
import 'package:odo24_mobile/presentatin/register_screen/register_screen.dart';
import 'package:odo24_mobile/presentatin/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const SplashScreen(),
  '/register': (context) => const RegisterScreen(),
  '/login': (context) => const LoginScreen(),
  '/login/password_recovery': (context) => const PasswordRecoveryScreen(),
  '/home': (context) => const HomeScreen(),
};
