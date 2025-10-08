import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/sensor_provider.dart';
import '../widgets/chart/chart_container.dart';
import '../widgets/chart/chart_type_selector.dart';
import '../widgets/chart/time_range_selector.dart';
import '../widgets/chart/chart_legend.dart';
import '../widgets/chart/stats_summary.dart';
import '../widgets/chart/chart_data_helper.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _selectedTimeRange = '1hour';
  String _selectedChartType = 'temperature';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SensorProvider>(
        builder: (context, sensorProvider, child) {
          final filteredData = ChartDataHelper.getFilteredData(
            sensorProvider.sensorHistory, 
            _selectedTimeRange
          );

          if (filteredData.isEmpty) {
            return _buildEmptyState(context, sensorProvider);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Chart Type Selector
                ChartTypeSelector(
                  selectedChartType: _selectedChartType,
                  onChartTypeChanged: (value) {
                    setState(() {
                      _selectedChartType = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Time Range Selector
                TimeRangeSelector(
                  selectedTimeRange: _selectedTimeRange,
                  onTimeRangeChanged: (value) {
                    setState(() {
                      _selectedTimeRange = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Chart Container
                ChartContainer(
                  data: filteredData,
                  chartType: _selectedChartType,
                  timeRangeLabel: TimeRangeSelector.getTimeRangeLabel(_selectedTimeRange),
                ),
                const SizedBox(height: 16),
                
                // Legend
                ChartLegend(chartType: _selectedChartType),
                
                // Stats Summary
                const SizedBox(height: 16),
                StatsSummary(
                  data: filteredData,
                  chartType: _selectedChartType,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, SensorProvider sensorProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart, 
            size: 64, 
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
          ),
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
              sensorProvider.fetchDataFromBlynk();
            },
            child: const Text('Fetch Data Now'),
          ),
        ],
      ),
    );
  }
}