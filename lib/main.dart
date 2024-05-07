import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/theme/odo24_theme.dart';
import 'package:odo24_mobile/data/auth/auth_data_provider.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/cars/data/cars_data_provider.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/services/data/services_provider.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_data_provider.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_repository.dart';
import 'package:odo24_mobile/features/splash/splash_screen.dart';
import 'package:sentry/sentry_io.dart';
import 'package:sentry_dio/sentry_dio.dart';

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

void main() async {
  await Sentry.init((options) {
    options.dsn = 'https://1535d3545bdf3ee95fcdcc1305dcac3d@o4506994624888832.ingest.us.sentry.io/4506994630524929';
    options.tracesSampleRate = 1.0;
  });
  runZonedGuarded(
    () {
      Intl.defaultLocale = 'ru_RU';

      final authRepository = AuthRepository(
        authDataProvider: AuthDataProvider(),
      );
      final dio = HttpAPI.newDio(
        authRepository: authRepository,
      );
      dio.addSentry();

      final dependencies = Dependencies(
        httpClient: HttpAPI.newDio(
          authRepository: authRepository,
        ),
        authRepository: authRepository,
        carsRepository: CarsRepository(
          carsDataProvider: CarsDataProvider(httpClient: dio),
        ),
        groupsRepository: GroupsRepository(
          groupsDataProvider: GroupsDataProvider(httpClient: dio),
        ),
        servicesRepository: ServicesRepository(
          servicesDataProvider: ServicesDataProvider(httpClient: dio),
        ),
      );

      runApp(DependenciesScope(
        dependencies: dependencies,
        child: const Odo24App(),
      ));
    },
    (error, stack) async {
      if (kDebugMode) {
        print('Err: $error\r\n$stack');
      } else {
        await Sentry.captureException(
          error,
          stackTrace: stack,
        );
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
      navigatorKey: navigatorKey,
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
      home: const SplashScreen(),
    );
  }
}
