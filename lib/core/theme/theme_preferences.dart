import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const _key = 'theme_pref_key';
  final _brightness = ValueNotifier(Brightness.light);

  ValueNotifier<Brightness> get brightness => _brightness;

  Future<void> setTheme(Brightness value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt(_key, value.index);
    //_brightness.value = value;
  }

  Future<Brightness> fetchBrightness() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final indexBrightness = sharedPreferences.getInt(_key) ?? Brightness.light.index;

    final value = Brightness.values.elementAt(indexBrightness);
    if (_brightness.value != value) {
      //_brightness.value = value;
    }
    return value;
  }
}
