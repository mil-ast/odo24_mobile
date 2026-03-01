import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

final class GroupsDependencies {
  final CarModel selectedCar;
  const GroupsDependencies({required this.selectedCar});
}

class GroupsDependenciesScope extends InheritedWidget {
  const GroupsDependenciesScope({required super.child, required this.dependencies, super.key});

  final GroupsDependencies dependencies;

  static GroupsDependencies? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupsDependenciesScope>()?.dependencies;
  }

  static GroupsDependencies of(BuildContext context) {
    final GroupsDependencies? result = maybeOf(context);
    assert(result != null, 'No GroupsDependenciesScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant GroupsDependenciesScope oldWidget) => dependencies != oldWidget.dependencies;
}
