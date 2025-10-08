import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/sensor_provider.dart';
import '../../models/sensor_data.dart';
import 'dart:math';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _selectedTimeRange = '1hour';
  String _selectedChartType = 'temperature';

  List<FlSpot> _createTemperatureSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.temperature);
    }).toList();
  }

  List<FlSpot> _createHumiditySpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.humidity);
    }).toList();
  }

  List<FlSpot> _createActivePowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.power);
    }).toList();
  }

  List<FlSpot> _createApparentPowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.apparentPower);
    }).toList();
  }

  List<FlSpot> _createReactivePowerSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.reactivePower);
    }).toList();
  }

  List<FlSpot> _createVoltageSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.voltage);
    }).toList();
  }

  List<FlSpot> _createCurrentSpots(List<SensorData> data) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final sensorData = entry.value;
      return FlSpot(index.toDouble(), sensorData.current);
    }).toList();
  }

  String _getChartTitle() {
    switch (_selectedChartType) {
      case 'temperature':
        return 'Temperature & Humidity';
      case 'power':
        return 'Power Consumption';
      case 'voltage':
        return 'Voltage & Current';
      default:
        return 'Temperature & Humidity';
    }
  }

  List<LineChartBarData> _getChartData(List<SensorData> data) {
    switch (_selectedChartType) {
      case 'temperature':
        return [
          LineChartBarData(
            spots: _createTemperatureSpots(data),
            isCurved: true,
            color: Colors.red,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: _createHumiditySpots(data),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ];
      
      case 'power':
        return [
          LineChartBarData(
            spots: _createActivePowerSpots(data),
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: _createApparentPowerSpots(data),
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: _createReactivePowerSpots(data),
            isCurved: true,
            color: Colors.purple,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ];
      
      case 'voltage':
        return [
          LineChartBarData(
            spots: _createVoltageSpots(data),
            isCurved: true,
            color: Colors.amber,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: _createCurrentSpots(data),
            isCurved: true,
            color: Colors.cyan,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ];
      
      default:
        return [];
    }
  }

  List<Widget> _getLegendItems() {
    switch (_selectedChartType) {
      case 'temperature':
        return [
          _buildLegendItem('Temperature', Colors.red),
          const SizedBox(width: 20),
          _buildLegendItem('Humidity', Colors.blue),
        ];
      
      case 'power':
        return [
          _buildLegendItem('Active Power', Colors.green),
          const SizedBox(width: 20),
          _buildLegendItem('Apparent Power', Colors.orange),
          const SizedBox(width: 20),
          _buildLegendItem('Reactive Power', Colors.purple),
        ];
      
      case 'voltage':
        return [
          _buildLegendItem('Voltage', Colors.amber),
          const SizedBox(width: 20),
          _buildLegendItem('Current', Colors.cyan),
        ];
      
      default:
        return [];
    }
  }

  Widget _buildStatsSummary(List<SensorData> data, BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    switch (_selectedChartType) {
      case 'temperature':
        final tempValues = data.map((d) => d.temperature).toList();
        final humValues = data.map((d) => d.humidity).toList();

        final avgTemp = tempValues.reduce((a, b) => a + b) / tempValues.length;
        final avgHum = humValues.reduce((a, b) => a + b) / humValues.length;
        final maxTemp = tempValues.reduce((a, b) => a > b ? a : b);
        final minTemp = tempValues.reduce((a, b) => a < b ? a : b);
        final maxHum = humValues.reduce((a, b) => a > b ? a : b);
        final minHum = humValues.reduce((a, b) => a < b ? a : b);

        return _buildTemperatureStats(avgTemp, avgHum, maxTemp, minTemp, maxHum, minHum, context);
      
      case 'power':
        final activePowerValues = data.map((d) => d.power).toList();
        final apparentPowerValues = data.map((d) => d.apparentPower).toList();
        final reactivePowerValues = data.map((d) => d.reactivePower).toList();

        final avgActive = activePowerValues.reduce((a, b) => a + b) / activePowerValues.length;
        final avgApparent = apparentPowerValues.reduce((a, b) => a + b) / apparentPowerValues.length;
        final avgReactive = reactivePowerValues.reduce((a, b) => a + b) / reactivePowerValues.length;
        final maxActive = activePowerValues.reduce((a, b) => a > b ? a : b);
        final maxApparent = apparentPowerValues.reduce((a, b) => a > b ? a : b);
        final maxReactive = reactivePowerValues.reduce((a, b) => a > b ? a : b);

        return _buildPowerStats(avgActive, avgApparent, avgReactive, maxActive, maxApparent, maxReactive, context);
      
      case 'voltage':
        final voltageValues = data.map((d) => d.voltage).toList();
        final currentValues = data.map((d) => d.current).toList();

        final avgVoltage = voltageValues.reduce((a, b) => a + b) / voltageValues.length;
        final avgCurrent = currentValues.reduce((a, b) => a + b) / currentValues.length;
        final maxVoltage = voltageValues.reduce((a, b) => a > b ? a : b);
        final maxCurrent = currentValues.reduce((a, b) => a > b ? a : b);
        final minVoltage = voltageValues.reduce((a, b) => a < b ? a : b);
        final minCurrent = currentValues.reduce((a, b) => a < b ? a : b);

        return _buildVoltageStats(avgVoltage, avgCurrent, maxVoltage, maxCurrent, minVoltage, minCurrent, context);
      
      default:
        return const SizedBox();
    }
  }

  Widget _buildTemperatureStats(double avgTemp, double avgHum, double maxTemp, double minTemp, double maxHum, double minHum, BuildContext context) {
    return _buildStatsCard(
      context,
      'Temperature & Humidity Statistics',
      Icons.thermostat,
      [
        _buildStatCard('Avg Temp', '${avgTemp.toStringAsFixed(1)}°C', Icons.thermostat_auto, Colors.red, context),
        _buildStatCard('Avg Hum', '${avgHum.toStringAsFixed(1)}%', Icons.water_drop, Colors.blue, context),
        _buildStatCard('Max Temp', '${maxTemp.toStringAsFixed(1)}°C', Icons.arrow_upward, Colors.red, context),
        _buildStatCard('Min Temp', '${minTemp.toStringAsFixed(1)}°C', Icons.arrow_downward, Colors.red, context),
        _buildStatCard('Max Hum', '${maxHum.toStringAsFixed(1)}%', Icons.arrow_upward, Colors.blue, context),
        _buildStatCard('Min Hum', '${minHum.toStringAsFixed(1)}%', Icons.arrow_downward, Colors.blue, context),
      ],
    );
  }

  Widget _buildPowerStats(double avgActive, double avgApparent, double avgReactive, double maxActive, double maxApparent, double maxReactive, BuildContext context) {
    return _buildStatsCard(
      context,
      'Power Statistics',
      Icons.bolt,
      [
        _buildStatCard('Avg Active', '${avgActive.toStringAsFixed(1)} W', Icons.power, Colors.green, context),
        _buildStatCard('Avg Apparent', '${avgApparent.toStringAsFixed(1)} VA', Icons.flash_on, Colors.orange, context),
        _buildStatCard('Avg Reactive', '${avgReactive.toStringAsFixed(1)} VAR', Icons.energy_savings_leaf, Colors.purple, context),
        _buildStatCard('Max Active', '${maxActive.toStringAsFixed(1)} W', Icons.arrow_upward, Colors.green, context),
        _buildStatCard('Max Apparent', '${maxApparent.toStringAsFixed(1)} VA', Icons.arrow_upward, Colors.orange, context),
        _buildStatCard('Max Reactive', '${maxReactive.toStringAsFixed(1)} VAR', Icons.arrow_upward, Colors.purple, context),
      ],
    );
  }

  Widget _buildVoltageStats(double avgVoltage, double avgCurrent, double maxVoltage, double maxCurrent, double minVoltage, double minCurrent, BuildContext context) {
    return _buildStatsCard(
      context,
      'Voltage & Current Statistics',
      Icons.offline_bolt,
      [
        _buildStatCard('Avg Voltage', '${avgVoltage.toStringAsFixed(1)} V', Icons.bolt, Colors.amber, context),
        _buildStatCard('Avg Current', '${avgCurrent.toStringAsFixed(2)} A', Icons.electric_bolt, Colors.cyan, context),
        _buildStatCard('Max Voltage', '${maxVoltage.toStringAsFixed(1)} V', Icons.arrow_upward, Colors.amber, context),
        _buildStatCard('Max Current', '${maxCurrent.toStringAsFixed(2)} A', Icons.arrow_upward, Colors.cyan, context),
        _buildStatCard('Min Voltage', '${minVoltage.toStringAsFixed(1)} V', Icons.arrow_downward, Colors.amber, context),
        _buildStatCard('Min Current', '${minCurrent.toStringAsFixed(2)} A', Icons.arrow_downward, Colors.cyan, context),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context, String title, IconData icon, List<Widget> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatsGrid(context: context, items: items),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid({
    required BuildContext context,
    required List<Widget> items,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    
    int crossAxisCount;
    double childAspectRatio;
    double spacing;

    if (isTablet) {
      crossAxisCount = 3;
      childAspectRatio = 1.3; // Adjusted for larger fonts
      spacing = 16;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 1.1; // Adjusted for larger fonts
      spacing = 12;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: items,
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    
    double cardHeight;
    double iconSize;
    double labelFontSize;
    double valueFontSize;
    EdgeInsets padding;

final orientation = MediaQuery.of(context).orientation;

if (isTablet) {
  final bool isLandscape = orientation == Orientation.landscape;
  cardHeight = isLandscape ? 90 : 120; // ↓ shorter in landscape
  iconSize = isLandscape ? 24 : 28;
  labelFontSize = isLandscape ? 14 : 16;
  valueFontSize = isLandscape ? 28 : 38;
  padding = const EdgeInsets.all(16);
} else {
  cardHeight = 110;
  iconSize = 24;
  labelFontSize = 15;
  valueFontSize = 20;
  padding = const EdgeInsets.all(16);
}


    return Container(
      height: cardHeight,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: iconSize, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Increased spacing
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ... (keep all the existing helper methods like _getMinY, _getMaxY, etc.)

  double _getMinY(List<SensorData> data) {
    if (data.isEmpty) return 0;
    
    switch (_selectedChartType) {
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
      
      default:
        return 0;
    }
  }

  double _getMaxY(List<SensorData> data) {
    if (data.isEmpty) return 100;
    
    switch (_selectedChartType) {
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
      
      default:
        return 100;
    }
  }

  double _getGridInterval(List<SensorData> data) {
    final range = _getMaxY(data) - _getMinY(data);
    if (range <= 20) return 5;
    if (range <= 50) return 10;
    if (range <= 100) return 20;
    if (range <= 200) return 50;
    return 100;
  }

  List<SensorData> _getFilteredData(List<SensorData> allData) {
    final now = DateTime.now();
    switch (_selectedTimeRange) {
      case '1hour':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 1)))).toList();
      case '3hours':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 3)))).toList();
      case '24hours':
        return allData.where((data) => data.timestamp.isAfter(now.subtract(const Duration(hours: 24)))).toList();
      default:
        return allData;
    }
  }

  String _getTimeRangeLabel() {
    switch (_selectedTimeRange) {
      case '1hour':
        return 'Last Hour';
      case '3hours':
        return 'Last 3 Hours';
      case '24hours':
        return 'Last 24 Hours';
      default:
        return 'Last Hour';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SensorProvider>(
        builder: (context, sensorProvider, child) {
          final filteredData = _getFilteredData(sensorProvider.sensorHistory);

          if (filteredData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No Chart Data Available',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data will appear as sensor readings are collected',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {
                      context.read<SensorProvider>().fetchDataFromBlynk();
                    },
                    child: const Text('Fetch Data Now'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Chart Type Selector
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _buildChartTypeButton('temperature', Icons.thermostat_outlined, context),
                      _buildChartTypeButton('power', Icons.bolt_outlined, context),
                      _buildChartTypeButton('voltage', Icons.offline_bolt_outlined, context),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Time Range Selector
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _buildTimeRangeButton('1hour', '1H', context),
                      _buildTimeRangeButton('3hours', '3H', context),
                      _buildTimeRangeButton('24hours', '24H', context),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Chart Container
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '${_getChartTitle()} - ${_getTimeRangeLabel()}',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300, // Fixed chart height
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: _getGridInterval(filteredData),
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: _getGridInterval(filteredData),
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 11,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              minX: 0,
                              maxX: filteredData.length > 1 ? (filteredData.length - 1).toDouble() : 1,
                              minY: _getMinY(filteredData),
                              maxY: _getMaxY(filteredData),
                              lineBarsData: _getChartData(filteredData),
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: Theme.of(context).colorScheme.surface,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((touchedSpot) {
                                      final index = touchedSpot.spotIndex;
                                      if (index < filteredData.length) {
                                        final data = filteredData[index];
                                        final value = _getTooltipValue(data, touchedSpot.barIndex);
                                        return LineTooltipItem(
                                          value,
                                          TextStyle(
                                            color: _getTooltipColor(touchedSpot.barIndex),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                      return null;
                                    }).toList();
                                  },
                                ),
                                handleBuiltInTouches: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _getLegendItems(),
                      ),
                    ],
                  ),
                ),
                
                // Stats Summary
                const SizedBox(height: 16),
                _buildStatsSummary(filteredData, context),
                
              ],
            ),
          );
        },
      ),
    );
  }

  // ... (keep all the existing helper methods like _getTooltipValue, _buildChartTypeButton, etc.)

  String _getTooltipValue(SensorData data, int barIndex) {
    switch (_selectedChartType) {
      case 'temperature':
        return barIndex == 0 
            ? '${data.temperature.toStringAsFixed(1)}°C'
            : '${data.humidity.toStringAsFixed(1)}%';
      
      case 'power':
        switch (barIndex) {
          case 0: return '${data.power.toStringAsFixed(1)} W';
          case 1: return '${data.apparentPower.toStringAsFixed(1)} VA';
          case 2: return '${data.reactivePower.toStringAsFixed(1)} VAR';
          default: return '';
        }
      
      case 'voltage':
        return barIndex == 0
            ? '${data.voltage.toStringAsFixed(1)} V'
            : '${data.current.toStringAsFixed(2)} A';
      
      default:
        return '';
    }
  }

  Color _getTooltipColor(int barIndex) {
    switch (_selectedChartType) {
      case 'temperature':
        return barIndex == 0 ? Colors.red : Colors.blue;
      
      case 'power':
        switch (barIndex) {
          case 0: return Colors.green;
          case 1: return Colors.orange;
          case 2: return Colors.purple;
          default: return Colors.black;
        }
      
      case 'voltage':
        return barIndex == 0 ? Colors.amber : Colors.cyan;
      
      default:
        return Colors.black;
    }
  }

  Widget _buildChartTypeButton(String value, IconData icon, BuildContext context) {
    final isSelected = _selectedChartType == value;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedChartType = value;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String value, String label, BuildContext context) {
    final isSelected = _selectedTimeRange == value;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedTimeRange = value;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}