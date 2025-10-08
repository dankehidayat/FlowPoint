import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import 'chart_data_helper.dart';

class ChartContainer extends StatelessWidget {
  final List<SensorData> data;
  final String chartType;
  final String timeRangeLabel;

  const ChartContainer({
    super.key,
    required this.data,
    required this.chartType,
    required this.timeRangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '${ChartDataHelper.getChartTitle(chartType)} - $timeRangeLabel',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: LineChart(_buildChartData(context)),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridColor = isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.3);
    final textColor = isDark ? Colors.white.withOpacity(0.7) : Colors.grey;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: ChartDataHelper.getGridInterval(data, chartType),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: gridColor,
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
            interval: ChartDataHelper.getGridInterval(data, chartType),
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  value.toInt().toString(),
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: textColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: data.length > 1 ? (data.length - 1).toDouble() : 1,
      minY: ChartDataHelper.getMinY(data, chartType),
      maxY: ChartDataHelper.getMaxY(data, chartType),
      lineBarsData: _getLineBarsData(),
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          // Replaces tooltipBgColor
          getTooltipColor: (LineBarSpot touchedSpot) {
            return Theme.of(context).colorScheme.surface.withOpacity(0.95);
          },
          // Replaces tooltipRoundedRadius
          tooltipBorderRadius: BorderRadius.circular(8),
          // Tooltip content
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final spotIndex = barSpot.spotIndex;
              if (spotIndex >= data.length) {
                return null;
              }
              
              final sensorData = data[spotIndex];
              final value = _getTooltipValue(sensorData, barSpot.barIndex);
              final color = _getTooltipColor(barSpot.barIndex);
              
              return LineTooltipItem(
                '', // Empty main text
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                children: [
                  TextSpan(
                    text: _formatTime(sensorData.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          // Tooltip styling
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 6,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: 150,
        ),
      ),
    );
  }

  String _getTooltipValue(SensorData data, int barIndex) {
    switch (chartType) {
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
      
      default: return '';
    }
  }

  Color _getTooltipColor(int barIndex) {
    switch (chartType) {
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
      
      default: return Colors.black;
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  List<LineChartBarData> _getLineBarsData() {
    switch (chartType) {
      case 'temperature':
        return [
          LineChartBarData(
            spots: ChartDataHelper.createTemperatureSpots(data),
            isCurved: true,
            color: Colors.red,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createHumiditySpots(data),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
        ];
      
      case 'power':
        return [
          LineChartBarData(
            spots: ChartDataHelper.createActivePowerSpots(data),
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createApparentPowerSpots(data),
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createReactivePowerSpots(data),
            isCurved: true,
            color: Colors.purple,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
        ];
      
      case 'voltage':
        return [
          LineChartBarData(
            spots: ChartDataHelper.createVoltageSpots(data),
            isCurved: true,
            color: Colors.amber,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createCurrentSpots(data),
            isCurved: true,
            color: Colors.cyan,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            aboveBarData: BarAreaData(show: false),
          ),
        ];
      
      default: return [];
    }
  }
}