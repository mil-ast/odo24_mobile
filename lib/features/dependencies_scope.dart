import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/data/auth/auth_repository.dart';
import 'package:odo24_mobile/features/cars/data/cars_repository.dart';
import 'package:odo24_mobile/features/services/data/services_repository.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/groups_repository.dart';

final class Dependencies {
  final Dio httpClient;
  final IAuthRepository authRepository;
  final ICarsRepository carsRepository;
  final IGroupsRepository groupsRepository;
  final IServicesRepository servicesRepository;

  const Dependencies({
    required this.httpClient,
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
