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
              child: LineChart(_buildChartData()),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: ChartDataHelper.getGridInterval(data, chartType),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                    color: Colors.grey,
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
    );
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
          ),
          LineChartBarData(
            spots: ChartDataHelper.createHumiditySpots(data),
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
            spots: ChartDataHelper.createActivePowerSpots(data),
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createApparentPowerSpots(data),
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createReactivePowerSpots(data),
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
            spots: ChartDataHelper.createVoltageSpots(data),
            isCurved: true,
            color: Colors.amber,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: ChartDataHelper.createCurrentSpots(data),
            isCurved: true,
            color: Colors.cyan,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ];
      
      default: return [];
    }
  }
}