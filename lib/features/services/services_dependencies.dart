import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';

final class ServicesDependencies {
  final CarModel selectedCar;
  final GroupModel selectedGroup;
  const ServicesDependencies({required this.selectedCar, required this.selectedGroup});
}

class ServicesDependenciesScope extends InheritedWidget {
  const ServicesDependenciesScope({required super.child, required this.dependencies, super.key});

  final ServicesDependencies dependencies;

  static ServicesDependencies? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServicesDependenciesScope>()?.dependencies;
  }

  static ServicesDependencies of(BuildContext context) {
    final ServicesDependencies? result = maybeOf(context);
    assert(result != null, 'No ServicesDependenciesScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ServicesDependenciesScope oldWidget) => dependencies != oldWidget.dependencies;
}
