import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final defaultApp = await Firebase.initializeApp();
  FirebaseAuth.instanceFor(app: defaultApp);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(Odo24App());
}

class Odo24App extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const primaryColor = Color(0xff202427);
  static const secondColor = Color(0xfff2d3036);
  static const actionsColor = Color.fromRGBO(255, 152, 0, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODO24.mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        secondaryHeaderColor: secondColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
          backgroundColor: secondColor,
          toolbarTextStyle: TextStyle(color: Colors.white),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: secondColor),
        unselectedWidgetColor: Colors.black45,
        primaryColorLight: primaryColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: secondColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
            secondary: secondColor,
            primary: primaryColor,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: const TextStyle(color: Colors.white),
          labelColor: Colors.white,
          dividerColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha(180),
        ),

        /* 
        primaryColor: primaryColor,
        shadowColor: primaryColor,
        secondaryHeaderColor: secondColor,
        //primaryColorLight: Colors.black,
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        scaffoldBackgroundColor: Color(0xfff5f8fa),
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            surfaceTintColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 20),
            foregroundColor: primaryColor,
          ),
        ),
        appBarTheme: AppBarTheme(
          shadowColor: Colors.transparent,
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 26),
          actionsIconTheme: IconThemeData(color: actionsColor),
          toolbarHeight: 100,
        ),
        errorColor: Colors.red, */
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
