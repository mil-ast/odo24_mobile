import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_screen.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: AuthService().isAuth(),
      builder: (BuildContext context, AsyncSnapshot<bool?> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData && snap.data == true) {
            return HomeScreen();
          }
          return LoginScreen();
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
