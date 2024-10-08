import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:odo24_mobile/core/updater/data/updater_repository.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_repository.dart';

final class Dependencies {
  final String siteURL;
  final Dio httpClient;
  final MethodChannel methodChannel;
  final IAuthRepository authRepository;
  final IUpdaterRepository updaterRepository;
  final ICarsRepository carsRepository;
  final IGroupsRepository groupsRepository;
  final IServicesRepository servicesRepository;

  const Dependencies({
    required this.siteURL,
    required this.httpClient,
    required this.methodChannel,
    required this.authRepository,
    required this.updaterRepository,
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
