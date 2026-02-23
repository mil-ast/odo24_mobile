import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/http/middlewares/auth_middleware.dart';
import 'package:odo24_mobile/core/http/middlewares/json_middleware.dart';
import 'package:odo24_mobile/core/http/middlewares/status_code_middleware.dart';
import 'package:odo24_mobile/core/theme/odo24_theme.dart';
import 'package:odo24_mobile/core/theme/theme_preferences.dart';
import 'package:odo24_mobile/data/auth/auth_data_provider.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';
import 'package:odo24_mobile/features/auth_guard.dart';
import 'package:odo24_mobile/features/cars/data/cars_data_provider.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/data/groups_data_provider.dart';
import 'package:odo24_mobile/features/groups/data/groups_repository.dart';
import 'package:odo24_mobile/features/home/home_screen.dart';
import 'package:odo24_mobile/features/services/data/services_provider.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: RepaintBoundary(child: CircularProgressIndicator())),
      ),
    );
  }
}

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      Intl.defaultLocale = 'ru_RU';

      final sp = await SharedPreferences.getInstance();
      final authDataProvider = AuthDataProvider(sharedPreferences: sp);
      final authRepository = AuthRepository(authDataProvider: authDataProvider);

      final client = HttpAPI.newHttpClient();
      final httpClient = AppHttpClient(client, [
        const JsonContentTypeMiddleware(),
        AuthMiddleware(authService: AuthService(authRepository)),
        const StatusCodeMiddleware(),
      ]);
      final httpClientWithoutAuth = AppHttpClient(client, [
        const JsonContentTypeMiddleware(),
        const StatusCodeMiddleware(),
      ]);

      authDataProvider.setHttpClients(httpClient: httpClient, httpClientWithoutAuth: httpClientWithoutAuth);

      final dependencies = Dependencies(
        themePreferences: ThemePreferences(),
        httpClient: httpClient,
        sharedPreferences: sp,
        methodChannel: const MethodChannel('odo24/channel'),
        authService: AuthService.instance,
        carsRepository: CarsRepository(carsDataProvider: CarsDataProvider(httpClient: httpClient)),
        groupsRepository: GroupsRepository(groupsDataProvider: GroupsDataProvider(httpClient: httpClient)),
        servicesRepository: ServicesRepository(servicesDataProvider: ServicesDataProvider(httpClient: httpClient)),
      );

      runApp(
        DependenciesScope(
          dependencies: dependencies,
          child: const SafeArea(child: Odo24App()),
        ),
      );
    },
    (error, stack) {
      debugPrint('Err: $error\r\n\r\n$stack');
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
      future: themePreferences.fetchBrightness(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: themePreferences.brightness,
            builder: (context, brightness, _) {
              return MaterialApp(
                title: 'ODO24.mobile',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                /* theme: brightness == Brightness.dark
                    ? ODO24Theme.darkTheme
                    : ODO24Theme.lightTheme, */
                theme: ODO24Theme.lightTheme,
                debugShowMaterialGrid: false,
                localizationsDelegates: const [
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('ru', 'RU')],
                locale: const Locale('ru', 'RU'),
                home: AuthGuard(child: HomeScreen.create()),
              );
            },
          );
        }

        return const MaterialApp(home: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
