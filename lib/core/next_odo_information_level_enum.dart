import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';

enum NextODOInformationColorLevel {
  normal(1, ODO24Colors.success),
  warn(0.30, ODO24Colors.warning),
  alarm(0.10, ODO24Colors.alarm);

  final double factor;
  final Color color;
  const NextODOInformationColorLevel(this.factor, this.color);

  bool operator <(Object other) =>
      (other is NextODOInformationColorLevel &&
      runtimeType == other.runtimeType &&
      factor < other.factor);
}

/// Цвет бейджа "ближайшее обслуживание" по оставшемуся пробегу.
///
/// [carOdo] — текущий пробег автомобиля, [odo] — база отсчёта (пробег на
/// последнем обслуживании), [leftOdo] — сколько километров осталось до
/// следующего обслуживания.
Color nextODOColor({
  required int carOdo,
  required int odo,
  required int leftOdo,
}) {
  var factor = (carOdo - odo) / leftOdo;
  if (factor > 1) {
    factor = 1;
  } else if (factor < 0) {
    factor = 0;
  }
  final remainingFactor = 1 - factor;
  if (remainingFactor <= NextODOInformationColorLevel.alarm.factor) {
    return NextODOInformationColorLevel.alarm.color;
  } else if (remainingFactor <= NextODOInformationColorLevel.warn.factor) {
    return NextODOInformationColorLevel.warn.color;
  } else {
    return NextODOInformationColorLevel.normal.color;
  }
}
