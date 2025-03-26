import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/theme/odo24_theme.dart';
import 'package:odo24_mobile/core/theme/theme_preferences.dart';
import 'package:odo24_mobile/core/updater/data/updater_data_provider.dart';
import 'package:odo24_mobile/core/updater/data/updater_repository.dart';
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
//import 'package:sentry/sentry_io.dart';
//import 'package:sentry_dio/sentry_dio.dart';

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
  runZonedGuarded(
    () {
      Intl.defaultLocale = 'ru_RU';

      final authDataProvider = AuthDataProvider();
      final authRepository = AuthRepository(
        authDataProvider: authDataProvider,
      );
      final dio = HttpAPI.newDio(
        authRepository: authRepository,
        allowBadCertificate: kDebugMode,
      );

      final dioWithoutAuth = HttpAPI.newDioWithoutAuth(
        allowBadCertificate: kDebugMode,
      );

      authDataProvider.setHttpClients(
        dioWithoutAuth: dioWithoutAuth,
        dioWithAuth: dio,
      );

      final dependencies = Dependencies(
        themePreferences: ThemePreferences(),
        siteURL: Configs.siteURL,
        httpClient: dio,
        methodChannel: const MethodChannel('odo24/channel'),
        authRepository: authRepository,
        updaterRepository: UpdaterRepository(
          updaterDataProvider: UpdaterDataProvider(
            httpClient: Dio(
              BaseOptions(
                baseUrl: Configs.baseHost,
              ),
            ),
          ),
        ),
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
        ///Sentry
      }
    },
  );
}

class Odo24App extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const Odo24App({super.key});

  @override
  Widget build(BuildContext context) {
    final themePreferences = DependenciesScope.of(context).themePreferences;

    return FutureBuilder(
      future: themePreferences.getTheme(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: themePreferences.brightness,
            builder: (context, brightness, _) {
              return MaterialApp(
                title: 'ODO24.mobile',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: brightness == Brightness.dark ? ODO24Theme.darkTheme : ODO24Theme.lightTheme,
                debugShowMaterialGrid: false,
                localizationsDelegates: const [
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ru', 'RU'),
                ],
                locale: const Locale('ru', 'RU'),
                home: const SplashScreen(),
              );
            },
          );
        }

        return const MaterialApp(
          home: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
