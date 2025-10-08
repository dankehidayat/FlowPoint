// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _useMaterialYou = true;

  ThemeMode get themeMode => _themeMode;
  bool get useMaterialYou => _useMaterialYou;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setUseMaterialYou(bool value) {
    if (_useMaterialYou != value) {
      _useMaterialYou = value;
      // Use a small delay to ensure the UI updates smoothly
      Future.delayed(Duration.zero, () {
        notifyListeners();
      });
    }
  }
}