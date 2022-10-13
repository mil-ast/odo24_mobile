import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Odo24App());
}

class Odo24App extends StatelessWidget {
  static final primaryColor = Color(0xff22262b);
  static final secondColor = Color(0xfff2d3036);
  static final actionsColor = Color.fromRGBO(255, 152, 0, 1);

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
        primaryColorLight: Colors.black,
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
        scaffoldBackgroundColor: Color(0xfff5f8fa),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            surfaceTintColor: actionsColor,
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
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      locale: const Locale('ru', ''),
      initialRoute: '/',
      routes: routes,
    );
  }
}
