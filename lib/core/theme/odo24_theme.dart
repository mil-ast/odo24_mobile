import 'package:flutter/material.dart';
import './color_scheme.dart';

class ODO24Theme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: ODO24Colors.primary,
      secondaryHeaderColor: ODO24Colors.secondary,
      scaffoldBackgroundColor: const Color(0xfff9f9f9),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ODO24Colors.secondary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: ODO24Colors.secondary),
      unselectedWidgetColor: Colors.black45,
      primaryColorLight: ODO24Colors.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: ODO24Colors.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
          secondary: ODO24Colors.secondary,
          primary: ODO24Colors.primary,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: const TextStyle(color: Colors.white),
        labelColor: Colors.white,
        dividerColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(180),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ODO24Colors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
