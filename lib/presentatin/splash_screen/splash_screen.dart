import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: FutureBuilder(
        initialData: null,
        future: AuthService().isAuth(),
        builder: (BuildContext context, AsyncSnapshot<bool?> snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasData && snap.data == true) {
              return const HomeScreen();
            }
            return const LoginScreen();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
