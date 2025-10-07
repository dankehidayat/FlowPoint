import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorData {
  final double voltage;          // V0
  final double current;          // V1
  final double power;            // V2
  final double powerFactor;      // V3
  final double apparentPower;    // V4
  final double energy;           // V5
  final double frequency;        // V6
  final double reactivePower;    // V7
  final double temperature;      // V8
  final double humidity;         // V9
  final DateTime timestamp;
  final bool isOnline;

  SensorData({
    required this.voltage,
    required this.current,
    required this.power,
    required this.powerFactor,
    required this.apparentPower,
    required this.energy,
    required this.frequency,
    required this.reactivePower,
    required this.temperature,
    required this.humidity,
    required this.timestamp,
    required this.isOnline,
  });

  factory SensorData.fromJson(Map<String, dynamic> json, bool isOnline) {
    return SensorData(
      voltage: _parseDouble(json['V0'] ?? '0'),
      current: _parseDouble(json['V1'] ?? '0'),
      power: _parseDouble(json['V2'] ?? '0'),
      powerFactor: _parseDouble(json['V3'] ?? '0'),
      apparentPower: _parseDouble(json['V4'] ?? '0'),
      energy: _parseDouble(json['V5'] ?? '0'),
      frequency: _parseDouble(json['V6'] ?? '0'),
      reactivePower: _parseDouble(json['V7'] ?? '0'),
      temperature: _parseDouble(json['V8'] ?? '0'),
      humidity: _parseDouble(json['V9'] ?? '0'),
      timestamp: DateTime.now(),
      isOnline: isOnline,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}

class ChartData {
  final DateTime time;
  final double temperature;
  final double humidity;

  ChartData({
    required this.time,
    required this.temperature,
    required this.humidity,
  });
}

class SensorProvider with ChangeNotifier {
  List<SensorData> _sensorHistory = [];
  List<ChartData> _chartData = [];
  SensorData? _currentData;
  bool _isLoading = false;
  String _error = '';

  List<SensorData> get sensorHistory => _sensorHistory;
  List<ChartData> get chartData => _chartData;
  SensorData? get currentData => _currentData;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Blynk server configuration
  final String _blynkServer = 'iot.serangkota.go.id';
  final int _blynkPort = 8080;
  final String _authToken = 'yourtokenhere'; // Replace with your actual Blynk auth token

  Future<void> fetchDataFromBlynk() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Fetch data from all virtual pins (V0 to V9)
      final List<Future<http.Response>> requests = [];
      
      for (int i = 0; i <= 9; i++) {
        final url = Uri.http('$_blynkServer:$_blynkPort', '/$_authToken/get/V$i');
        requests.add(http.get(url));
      }

      final responses = await Future.wait(requests);
      
      // Parse responses
      final Map<String, dynamic> sensorData = {};
      bool allSuccessful = true;
      
      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];
        if (response.statusCode == 200) {
          // Blynk returns data in format: ["value"]
          final dynamic parsed = json.decode(response.body);
          if (parsed is List && parsed.isNotEmpty) {
            sensorData['V$i'] = parsed[0];
          } else {
            sensorData['V$i'] = '0';
            allSuccessful = false;
          }
        } else {
          sensorData['V$i'] = '0';
          allSuccessful = false;
        }
      }

      if (allSuccessful) {
        final newData = SensorData.fromJson(sensorData, true);
        _currentData = newData;
        _sensorHistory.add(newData);
        
        // Add to chart data
        _chartData.add(ChartData(
          time: newData.timestamp,
          temperature: newData.temperature,
          humidity: newData.humidity,
        ));
        
        // Keep only last 100 readings for chart
        if (_chartData.length > 100) {
          _chartData.removeAt(0);
        }
        
        // Keep only last 50 readings for history
        if (_sensorHistory.length > 50) {
          _sensorHistory.removeAt(0);
        }
        _error = ''; // Clear error on successful connection
      } else {
        _error = 'Partial data received from server';
        // Still use the data we got, but mark as offline
        final newData = SensorData.fromJson(sensorData, false);
        _currentData = newData;
      }

    } catch (e) {
      _error = 'Failed to connect to server: $e';
      print('Error fetching Blynk data: $e');
      // Don't create demo data - keep existing data if available
      // Only set error, don't modify _currentData
      if (_currentData == null) {
        // If no data exists, create empty offline data structure
        _currentData = SensorData(
          voltage: 0.0,
          current: 0.0,
          power: 0.0,
          powerFactor: 0.0,
          apparentPower: 0.0,
          energy: 0.0,
          frequency: 0.0,
          reactivePower: 0.0,
          temperature: 0.0,
          humidity: 0.0,
          timestamp: DateTime.now(),
          isOnline: false,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get chart data for the last hour
  List<ChartData> getChartDataLastHour() {
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    return _chartData.where((data) => data.time.isAfter(oneHourAgo)).toList();
  }

  // Get chart data for the last 24 hours
  List<ChartData> getChartDataLast24Hours() {
    final oneDayAgo = DateTime.now().subtract(const Duration(hours: 24));
    return _chartData.where((data) => data.time.isAfter(oneDayAgo)).toList();
  }

  // Clear chart data
  void clearChartData() {
    _chartData.clear();
    notifyListeners();
  }
}
