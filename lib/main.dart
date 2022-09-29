import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Odo24App());
}

class Odo24App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff222527);

    return MaterialApp(
      title: 'ODO24.mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
        ),
        errorColor: Colors.red,
      ),
      builder: (context, w) => Navigator(
        onGenerateRoute: (RouteSettings rs) {
          return MaterialPageRoute(
            builder: (ctx) => const SplashScreen(),
          );
        },
      ),
    );
  }
}
