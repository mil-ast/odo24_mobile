import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odo24_mobile/core/theme/theme_preferences.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Dependencies {
  final String siteURL;
  final ThemePreferences themePreferences;
  final Dio httpClient;
  final MethodChannel methodChannel;
  final IAuthRepository authRepository;
  final ICarsRepository carsRepository;
  final IGroupsRepository groupsRepository;
  final IServicesRepository servicesRepository;
  final SharedPreferences sharedPreferences;

  const Dependencies({
    required this.themePreferences,
    required this.siteURL,
    required this.httpClient,
    required this.sharedPreferences,
    required this.methodChannel,
    required this.authRepository,
    required this.carsRepository,
    required this.groupsRepository,
    required this.servicesRepository,
  });
}

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  static Dependencies? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DependenciesScope>()?.dependencies;
  }

  static Dependencies of(BuildContext context) {
    final Dependencies? result = maybeOf(context);
    assert(result != null, 'No DependenciesScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant DependenciesScope oldWidget) => dependencies != oldWidget.dependencies;
}
