import 'package:fl_chart/fl_chart.dart';
import '../../../models/sensor_data.dart';
import 'dart:math';

class ChartDataHelper {
  static List<FlSpot> createTemperatureSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.temperature);
    }).toList();
  }

  static List<FlSpot> createHumiditySpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.humidity);
    }).toList();
  }

  static List<FlSpot> createActivePowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.power);
    }).toList();
  }

  static List<FlSpot> createApparentPowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.apparentPower);
    }).toList();
  }

  static List<FlSpot> createReactivePowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.reactivePower);
    }).toList();
  }

  static List<FlSpot> createVoltageSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.voltage);
    }).toList();
  }

  static List<FlSpot> createCurrentSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.current);
    }).toList();
  }

  static String getChartTitle(String chartType) {
    switch (chartType) {
      case 'temperature': return 'Temperature & Humidity';
      case 'power': return 'Power Consumption';
      case 'voltage': return 'Voltage & Current';
      default: return 'Temperature & Humidity';
    }
  }

  static double getMinY(List<SensorData> data, String chartType) {
    if (data.isEmpty) return 0;
    
    switch (chartType) {
      case 'temperature':
        final minTemp = data.map((d) => d.temperature).reduce(min);
        final minHum = data.map((d) => d.humidity).reduce(min);
        return (minTemp < minHum ? minTemp : minHum).floorToDouble() - 5;
      
      case 'power':
        final minActive = data.map((d) => d.power).reduce(min);
        final minApparent = data.map((d) => d.apparentPower).reduce(min);
        final minReactive = data.map((d) => d.reactivePower).reduce(min);
        final overallMin = [minActive, minApparent, minReactive].reduce(min);
        return (overallMin * 0.8).floorToDouble();
      
      case 'voltage':
        final minVoltage = data.map((d) => d.voltage).reduce(min);
        final minCurrent = data.map((d) => d.current).reduce(min);
        final overallMin = minVoltage < minCurrent ? minVoltage : minCurrent;
        return (overallMin * 0.9).floorToDouble();
      
      default: return 0;
    }
  }

  static double getMaxY(List<SensorData> data, String chartType) {
    if (data.isEmpty) return 100;
    
    switch (chartType) {
      case 'temperature':
        final maxTemp = data.map((d) => d.temperature).reduce(max);
        final maxHum = data.map((d) => d.humidity).reduce(max);
        return (maxTemp > maxHum ? maxTemp : maxHum).ceilToDouble() + 5;
      
      case 'power':
        final maxActive = data.map((d) => d.power).reduce(max);
        final maxApparent = data.map((d) => d.apparentPower).reduce(max);
        final maxReactive = data.map((d) => d.reactivePower).reduce(max);
        final overallMax = [maxActive, maxApparent, maxReactive].reduce(max);
        return (overallMax * 1.2).ceilToDouble();
      
      case 'voltage':
        final maxVoltage = data.map((d) => d.voltage).reduce(max);
        final maxCurrent = data.map((d) => d.current).reduce(max);
        final overallMax = maxVoltage > maxCurrent ? maxVoltage : maxCurrent;
        return (overallMax * 1.1).ceilToDouble();
      
      default: return 100;
    }
  }

  static double getGridInterval(List<SensorData> data, String chartType) {
    final range = getMaxY(data, chartType) - getMinY(data, chartType);
    if (range <= 20) return 5;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 200) return 50;
    return 100;
  }

  static List<SensorData> getFilteredData(List<SensorData> allData, String timeRange) {
    final now = DateTime.now();
    switch (timeRange) {
      case '1hour':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 1)))).toList();
      case '3hours':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 3)))).toList();
      case '24hours':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 24)))).toList();
      default: return allData;
    }
  }

  // Helper method to format time for tooltips
  static String formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}