import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const _key = 'theme_pref_key';
  final brightness = ValueNotifier(Brightness.light);

  ThemePreferences();

  Future<void> setTheme(Brightness value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(_key, value.index);
    brightness.value = value;
  }

  Future<Brightness> getTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final indexBrightness = sharedPreferences.getInt(_key) ?? Brightness.light.index;

    final value = Brightness.values.elementAt(indexBrightness);
    if (brightness.value != value) {
      brightness.value = value;
    }
    return value;
  }
}
