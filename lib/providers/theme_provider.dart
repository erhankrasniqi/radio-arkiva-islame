import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Options { automatic, dark, light }

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Options get selectedOption {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Options.dark;
      case ThemeMode.light:
        return Options.light;
      case ThemeMode.system:
        return Options.automatic;
    }
  }

  ThemeProvider() {
    Future.delayed(Duration.zero, _loadTheme);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString("theme") ?? "automatic";

    switch (savedTheme) {
      case "dark":
        _themeMode = ThemeMode.dark;
        break;
      case "light":
        _themeMode = ThemeMode.light;
        break;
      case "automatic":
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  Future<void> setTheme(Options option) async {
    final prefs = await SharedPreferences.getInstance();

    switch (option) {
      case Options.dark:
        _themeMode = ThemeMode.dark;
        prefs.setString("theme", "dark");
        break;
      case Options.light:
        _themeMode = ThemeMode.light;
        prefs.setString("theme", "light");
        break;
      case Options.automatic:
        _themeMode = ThemeMode.system;
        prefs.setString("theme", "automatic");
        break;
    }
    notifyListeners();
  }
}
