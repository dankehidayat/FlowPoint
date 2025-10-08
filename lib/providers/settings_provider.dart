// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _useGaugeView = false;

  bool get useGaugeView => _useGaugeView;

  void setUseGaugeView(bool value) {
    _useGaugeView = value;
    notifyListeners();
  }

  Color getTemperatureColor(double temperature) {
    if (temperature < 18) return Colors.blue;
    if (temperature > 28) return Colors.red;
    return Colors.green;
  }

  Color getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity > 70) return Colors.blue;
    return Colors.green;
  }
}