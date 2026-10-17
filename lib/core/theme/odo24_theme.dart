import 'package:flutter/material.dart';

import './color_scheme.dart';

abstract class ODO24Theme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      colorScheme: const ColorScheme.light(
        primary: ODO24LightThemeColors.primary,
        secondary: ODO24LightThemeColors.secondary,
        inversePrimary: Colors.white,
        tertiary: ODO24LightThemeColors.tertiary,
        error: ODO24Colors.alarm,
      ),
      primaryColor: ODO24LightThemeColors.primary,
      secondaryHeaderColor: const Color(0xff2d3036),
      scaffoldBackgroundColor: ODO24LightThemeColors.primary,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ODO24LightThemeColors.primary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0xff2d3036)),
      unselectedWidgetColor: Colors.black45,
      primaryColorLight: ODO24LightThemeColors.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xff2d3036),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: const Color(0xff2d3036), primary: ODO24LightThemeColors.primary),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(color: Colors.white),
        labelColor: Colors.white,
        dividerColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(180),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ODO24Colors.success,
        foregroundColor: Colors.white,
        iconSize: 36,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
        elevation: 8, // Тень
      ),
      popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color.fromARGB(255, 255, 106, 69),
          disabledIconColor: const Color.fromARGB(255, 201, 201, 201),
          disabledBackgroundColor: const Color.fromARGB(255, 131, 100, 92),
          textStyle: const TextStyle(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 235, 235, 235)),
          foregroundColor: WidgetStatePropertyAll(Colors.black),
          overlayColor: WidgetStatePropertyAll(Color.fromARGB(255, 163, 163, 163)),
          shadowColor: WidgetStatePropertyAll(ODO24LightThemeColors.secondary),
          surfaceTintColor: WidgetStatePropertyAll(ODO24LightThemeColors.secondary),
          side: WidgetStatePropertyAll(BorderSide(color: ODO24LightThemeColors.tertiary, width: 1)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: ODO24LightThemeColors.active,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color.fromARGB(255, 131, 100, 92),
          iconSize: 24,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color.fromARGB(255, 240, 240, 240),
        filled: true,
        floatingLabelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        labelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        hintStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        helperStyle: TextStyle(color: ODO24LightThemeColors.primary),
        prefixStyle: TextStyle(color: ODO24LightThemeColors.tertiary),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: ODO24LightThemeColors.primary),
        suffixStyle: TextStyle(color: ODO24LightThemeColors.primary),
        focusColor: ODO24LightThemeColors.primary,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        isDense: false,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 192, 192, 192), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF858585), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 192, 192, 192), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 248, 96, 96), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: Colors.white,
        height: 60,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ODO24Colors.inverseTextColor);
          }
          return const IconThemeData(color: Colors.white);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: Colors.grey);
        }),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ODO24LightThemeColors.tertiary,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ODO24LightThemeColors.tertiary, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        textStyle: TextStyle(color: ODO24LightThemeColors.primary, fontSize: 16),
      ),
    );
  }
}