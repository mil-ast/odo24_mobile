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
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: ODO24DarkThemeColors.primary,
        toolbarTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.white),
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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: ODO24DarkThemeColors.secondary, primary: ODO24DarkThemeColors.primary),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: const TextStyle(color: Colors.white),
        labelColor: Colors.white,
        dividerColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.white.withAlpha(180),
      ),
      /* floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ODO24DarkThemeColors.primary,
        foregroundColor: Colors.white,
        iconSize: 36,
      ), */
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple, // Цвет фона
        foregroundColor: Colors.white, // Цвет иконки
        hoverColor: Colors.purpleAccent, // При наведении (desktop)
        shape: RoundedRectangleBorder(
          // Форма (например, скругленный квадрат)
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8, // Тень
      ),
      popupMenuTheme: const PopupMenuThemeData(color: ODO24DarkThemeColors.primary),
      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll(ODO24DarkThemeColors.tertiary),
        overlayColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
        thumbColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
        trackOutlineColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(24),
          backgroundColor: const WidgetStatePropertyAll(ODO24LightThemeColors.active),
          foregroundColor: const WidgetStatePropertyAll(ODO24LightThemeColors.active),
          overlayColor: WidgetStatePropertyAll(ODO24DarkThemeColors.primary.withValues(alpha: 200)),
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(ODO24LightThemeColors.active),
          foregroundColor: WidgetStatePropertyAll(ODO24LightThemeColors.active),
          overlayColor: WidgetStatePropertyAll(ODO24LightThemeColors.active),
          shadowColor: WidgetStatePropertyAll(ODO24LightThemeColors.active),
          surfaceTintColor: WidgetStatePropertyAll(ODO24LightThemeColors.active),
          side: WidgetStatePropertyAll(BorderSide(color: ODO24DarkThemeColors.tertiary, width: 1)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: ODO24DarkThemeColors.secondary,
        filled: true,
        floatingLabelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        labelStyle: TextStyle(color: ODO24Colors.inverseTextColor),
        hintStyle: TextStyle(color: ODO24DarkThemeColors.tertiary),
        helperStyle: TextStyle(color: ODO24DarkThemeColors.tertiary),
        prefixStyle: TextStyle(color: ODO24DarkThemeColors.tertiary),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: ODO24DarkThemeColors.primary),
        suffixStyle: TextStyle(color: ODO24DarkThemeColors.primary),
        focusColor: ODO24DarkThemeColors.primary,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0E0F14), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF181A22), width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ODO24DarkThemeColors.secondary,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF181A22), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
        textStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
