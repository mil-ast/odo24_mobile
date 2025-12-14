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
      (other is NextODOInformationColorLevel && runtimeType == other.runtimeType && factor < other.factor);
}
