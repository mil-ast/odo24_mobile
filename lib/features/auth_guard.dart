import 'package:flutter/material.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService.instance.authState,
      initialData: AuthService.instance.isAuth,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final isAuth = snapshot.data ?? false;
        if (isAuth) {
          return child;
        }
        return const LoginScreen();
      },
    );
  }
}
