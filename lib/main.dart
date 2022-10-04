import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/splash_screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Odo24App());
}

class Odo24App extends StatelessWidget {
  static final primaryColor = Color(0xff22262b);
  static final secondColor = Color(0xfff2d3036);
  static final actionsColor = Color(0xff89ec8d);

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Color(0xff222527);

    return MaterialApp(
      title: 'ODO24.mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        shadowColor: Colors.transparent,
        secondaryHeaderColor: primaryColor,
        scaffoldBackgroundColor: Color(0xfff5f8fa),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 97, 182, 99),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20),
            foregroundColor: actionsColor,
          ),
        ),
        appBarTheme: AppBarTheme(
          shadowColor: Colors.transparent,
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          actionsIconTheme: IconThemeData(color: actionsColor),
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
