import 'package:flutter/material.dart';
import './color_scheme.dart';

abstract class ODO24Theme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ODO24LightThemeColors.primary,
        secondary: ODO24LightThemeColors.secondary,
        inversePrimary: Colors.white,
        tertiary: ODO24LightThemeColors.tertiary,
      ),
      primaryColor: ODO24LightThemeColors.primary,
      secondaryHeaderColor: const Color(0xff2d3036),
      scaffoldBackgroundColor: const Color(0xfff8f9fa),
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ODO24LightThemeColors.primary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
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
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
          secondary: const Color(0xff2d3036),
          primary: ODO24LightThemeColors.primary,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(ODO24LightThemeColors.link),
          textStyle: WidgetStatePropertyAll(TextStyle(color: ODO24LightThemeColors.link)),
          iconColor: WidgetStatePropertyAll(ODO24LightThemeColors.link),
        ),
      ),
      cardTheme: CardThemeData(
        color: ODO24LightThemeColors.secondary,
        shadowColor: const Color.fromARGB(255, 250, 250, 250),
        margin: const EdgeInsets.all(12),
        surfaceTintColor: ODO24LightThemeColors.secondary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color.fromARGB(255, 231, 231, 231),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
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
        backgroundColor: ODO24LightThemeColors.primary,
        foregroundColor: Colors.white,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 235, 235, 235)),
          foregroundColor: WidgetStatePropertyAll(Colors.black),
          overlayColor: WidgetStatePropertyAll(Color.fromARGB(255, 163, 163, 163)),
          shadowColor: WidgetStatePropertyAll(ODO24LightThemeColors.secondary),
          surfaceTintColor: WidgetStatePropertyAll(ODO24LightThemeColors.secondary),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: ODO24LightThemeColors.tertiary,
              width: 1,
            ),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(24),
          backgroundColor: const WidgetStatePropertyAll(ODO24LightThemeColors.tertiary),
          foregroundColor: const WidgetStatePropertyAll(ODO24Colors.inverseTextColor),
          overlayColor: WidgetStatePropertyAll(ODO24LightThemeColors.primary.withValues(alpha: 200)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color.fromARGB(255, 240, 240, 240),
        filled: true,
        floatingLabelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        labelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        hintStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        helperStyle: TextStyle(color: ODO24LightThemeColors.tertiary),
        prefixStyle: TextStyle(color: ODO24LightThemeColors.tertiary),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: ODO24LightThemeColors.primary),
        suffixStyle: TextStyle(color: ODO24LightThemeColors.primary),
        focusColor: ODO24LightThemeColors.primary,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF858585),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 192, 192, 192),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ODO24LightThemeColors.tertiary,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: ODO24LightThemeColors.tertiary,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        textStyle: TextStyle(
          color: ODO24LightThemeColors.primary,
          fontSize: 16,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ODO24DarkThemeColors.primary,
        secondary: ODO24DarkThemeColors.secondary,
        inversePrimary: Colors.white,
        tertiary: ODO24DarkThemeColors.tertiary,
      ),
      primaryColor: ODO24DarkThemeColors.primary,
      secondaryHeaderColor: ODO24DarkThemeColors.secondary,
      scaffoldBackgroundColor: ODO24DarkThemeColors.primary,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ODO24DarkThemeColors.primary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: ODO24DarkThemeColors.secondary),
      unselectedWidgetColor: Colors.black45,
      primaryColorLight: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: ODO24DarkThemeColors.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        ),
      ),
      buttonTheme: ButtonThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
          secondary: ODO24DarkThemeColors.secondary,
          primary: ODO24DarkThemeColors.primary,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(ODO24DarkThemeColors.link),
          textStyle: WidgetStatePropertyAll(TextStyle(color: ODO24DarkThemeColors.link)),
          iconColor: WidgetStatePropertyAll(ODO24DarkThemeColors.link),
        ),
      ),
      cardTheme: CardThemeData(
        color: ODO24DarkThemeColors.secondary,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(10),
        surfaceTintColor: ODO24DarkThemeColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
        backgroundColor: ODO24DarkThemeColors.primary,
        foregroundColor: Colors.white,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: ODO24DarkThemeColors.primary,
      ),
      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll(ODO24DarkThemeColors.tertiary),
        overlayColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
        thumbColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
        trackOutlineColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(24),
          backgroundColor: const WidgetStatePropertyAll(ODO24DarkThemeColors.tertiary),
          foregroundColor: const WidgetStatePropertyAll(ODO24Colors.inverseTextColor),
          overlayColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary.withValues(alpha: 200)),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(ODO24DarkThemeColors.secondary),
          shadowColor: WidgetStatePropertyAll(ODO24DarkThemeColors.secondary),
          surfaceTintColor: WidgetStatePropertyAll(ODO24DarkThemeColors.secondary),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: ODO24DarkThemeColors.tertiary,
              width: 1,
            ),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: ODO24DarkThemeColors.secondary,
        filled: true,
        floatingLabelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        labelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        hintStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        helperStyle: TextStyle(color: ODO24DarkThemeColors.tertiary),
        prefixStyle: TextStyle(color: ODO24DarkThemeColors.tertiary),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: ODO24DarkThemeColors.primary),
        suffixStyle: TextStyle(color: ODO24DarkThemeColors.primary),
        focusColor: ODO24DarkThemeColors.primary,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 14, 15, 20),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF181A22),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
            //shadowColor: WidgetStatePropertyAll(Colors.amber),
            //backgroundColor: WidgetStatePropertyAll(Colors.amber),
            ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ODO24DarkThemeColors.secondary,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF181A22),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
