import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/sensor_data.dart';

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
  final String _authToken = '';

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
        // Gunakan factory constructor dari models
        final newData = SensorData.fromBlynkJson(sensorData, true);
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
        final newData = SensorData.fromBlynkJson(sensorData, false);
        _currentData = newData;
      }

    } catch (e) {
      _error = 'Failed to connect to server: $e';
      print('Error fetching Blynk data: $e');
      // Use empty data instead of creating manually
      _currentData ??= SensorData.empty();
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