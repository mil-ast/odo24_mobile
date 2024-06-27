import 'package:flutter/material.dart';

enum NextODOInformationColorLevel {
  normal(1, Color.fromRGBO(200, 230, 201, 1)),
  warn(0.30, Color.fromRGBO(255, 204, 128, 1)),
  alarm(0.10, Color.fromRGBO(255, 171, 145, 1));

  final double factor;
  final Color color;
  const NextODOInformationColorLevel(this.factor, this.color);
}
