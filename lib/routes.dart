import 'package:flutter/cupertino.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/presentatin/splash_screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const SplashScreen(),
  '/login': (context) => LoginScreen(),
  '/home': (context) => const HomeScreen(),
};
