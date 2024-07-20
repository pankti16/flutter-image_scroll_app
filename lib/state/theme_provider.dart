import 'package:flutter/material.dart';
import 'package:image_scroll_app/service/theme_service.dart';
import 'package:image_scroll_app/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeModeType = ThemeMode.system;
  late ThemePreference _themePreference;
  late final ThemeService _service;

  ThemeMode get themeMode => getTheme(_themePreference);

  ThemeProvider() {
    _service = ThemeService();
    setPersistentTheme();
  }

  setPersistentTheme() async {
    final value = await _service.getTheme();
    _themePreference = ThemePreference.values[value];
    themeModeType = getTheme(_themePreference);
    notifyListeners();
  }

  ThemeMode getTheme(ThemePreference themePreference) {
    switch (themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  ThemePreference getPreference(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return ThemePreference.light;
      case ThemeMode.dark:
        return ThemePreference.dark;
      case ThemeMode.system:
        return ThemePreference.system;
      default:
        return ThemePreference.system;
    }
  }

  void updateThemeData(ThemeMode mode) {
    themeModeType = mode;
    _themePreference = getPreference(mode);
    _service.setTheme(getPreference(mode));
    notifyListeners();
  }
}