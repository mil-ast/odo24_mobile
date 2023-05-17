import 'package:flutter/material.dart';

class ODO24Colors {
  static const Color primary = Color(0xff202427);
  static const secondary = Color(0xff2d3036);
  static const actions = Color(0xFFFF9800);
  static const success = Color(0xFF73ba00);
  static const warning = Color(0xffff5c00);
}

extension ColorSchemeExt on ColorScheme {
  Color get primary => ODO24Colors.primary;
  Color get secondary => ODO24Colors.secondary;
  Color get actions => ODO24Colors.actions;
  Color get success => ODO24Colors.success;
  Color get warning => ODO24Colors.warning;
}
