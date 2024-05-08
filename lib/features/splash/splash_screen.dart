import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/cars/cars_screen.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = DependenciesScope.of(context).authRepository;
    return FutureBuilder(
      future: authRepository.isAuth,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snap.data == true) {
          return const CarsScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
