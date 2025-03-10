import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';

enum NextODOInformationColorLevel {
  //normal(1, Color.fromRGBO(200, 230, 201, 1)),
  normal(1, ODO24Colors.success),
  //warn(0.30, Color.fromRGBO(255, 204, 128, 1)),
  warn(0.30, ODO24Colors.warning),
  //alarm(0.10, Color.fromRGBO(255, 171, 145, 1));
  alarm(0.10, ODO24Colors.alarm);

  final double factor;
  final Color color;
  const NextODOInformationColorLevel(this.factor, this.color);
}
