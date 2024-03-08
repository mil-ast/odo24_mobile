import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/theme/odo24_theme.dart';
import 'package:odo24_mobile/routes.dart';

Future<void> main() async {
  runZonedGuarded(
    () {
      Intl.defaultLocale = 'ru_RU';
      runApp(const Odo24App());
    },
    (error, stack) {
      if (kDebugMode) {
        print('Err: $error\r\n$stack');
      }
    },
  );
}

class Odo24App extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const Odo24App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODO24.mobile',
      debugShowCheckedModeBanner: false,
      theme: ODO24Theme.lightTheme,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''),
      ],
      locale: const Locale('ru', ''),
      initialRoute: '/',
      routes: routes,
    );
  }
}
