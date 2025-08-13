import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    final themeMode = await AppConstants.getThemeMode();
    if (themeMode != null) {
      switch (themeMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
  }

  Future<void> setThemeMode(String themeMode) async {
    await AppConstants.setThemeMode(themeMode);
    switch (themeMode) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
