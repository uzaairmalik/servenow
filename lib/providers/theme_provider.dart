import 'package:flutter/material.dart';

/// Holds light/dark mode. Screens read `mode` only — they never build
/// their own theme logic, so the toggle in Profile works app-wide.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
