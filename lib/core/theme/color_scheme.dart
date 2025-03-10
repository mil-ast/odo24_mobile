import 'package:flutter/material.dart';

abstract class ODO24Colors {
  static const actions = Color(0xFFfdde67);
  static const success = Color(0xFF88d8a7);
  static const warning = Color(0xffe9ad79);
  static const alarm = Color(0xffff8c61);
  static const inverseTextColor = Color(0xff020006);
}

abstract class ODO24LightThemeColors {
  static const primary = Color(0xff202427);
  static const secondary = Color(0xFFF8F8F8);
  static const tertiary = Color.fromARGB(255, 223, 223, 223);
  static const link = Color(0xFF0085F1);
}

abstract class ODO24DarkThemeColors {
  static const primary = Color(0xff222531);
  static const secondary = Color(0xff323645);
  static const tertiary = Color(0xFF787f9a);
  static const link = Color(0xFF109BD6);
}

extension ColorSchemeExt on ColorScheme {
  Color get actions => ODO24Colors.actions;
  Color get success => ODO24Colors.success;
  Color get warning => ODO24Colors.warning;
  Color get inverseTextColor => ODO24Colors.inverseTextColor;
}
