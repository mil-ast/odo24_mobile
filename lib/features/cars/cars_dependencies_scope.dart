import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class CarsDependenciesScope extends InheritedWidget {
  final CarModel selectedCar;

  const CarsDependenciesScope({super.key, required this.selectedCar, required super.child});

  static CarsDependenciesScope of(BuildContext context) {
    final model = context.dependOnInheritedWidgetOfExactType<CarsDependenciesScope>();

    assert(model?.selectedCar != null, 'No DependenciesScope found in context');
    return model!;
  }

  @override
  bool updateShouldNotify(covariant CarsDependenciesScope oldWidget) => selectedCar != oldWidget.selectedCar;
}
