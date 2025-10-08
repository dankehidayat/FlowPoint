import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';

class StatsSummary extends StatelessWidget {
  final List<SensorData> data;
  final String chartType;

  const StatsSummary({
    super.key,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    switch (chartType) {
      case 'temperature':
        return _buildTemperatureStats(context);
      case 'power':
        return _buildPowerStats(context);
      case 'voltage':
        return _buildVoltageStats(context);
      default:
        return const SizedBox();
    }
  }

  Widget _buildTemperatureStats(BuildContext context) {
    final tempValues = data.map((d) => d.temperature).toList();
    final humValues = data.map((d) => d.humidity).toList();

    final avgTemp = tempValues.reduce((a, b) => a + b) / tempValues.length;
    final avgHum = humValues.reduce((a, b) => a + b) / humValues.length;
    final maxTemp = tempValues.reduce((a, b) => a > b ? a : b);
    final minTemp = tempValues.reduce((a, b) => a < b ? a : b);
    final maxHum = humValues.reduce((a, b) => a > b ? a : b);
    final minHum = humValues.reduce((a, b) => a < b ? a : b);

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

  Widget _buildPowerStats(BuildContext context) {
    final activePowerValues = data.map((d) => d.power).toList();
    final apparentPowerValues = data.map((d) => d.apparentPower).toList();
    final reactivePowerValues = data.map((d) => d.reactivePower).toList();

    final avgActive = activePowerValues.reduce((a, b) => a + b) / activePowerValues.length;
    final avgApparent = apparentPowerValues.reduce((a, b) => a + b) / apparentPowerValues.length;
    final avgReactive = reactivePowerValues.reduce((a, b) => a + b) / reactivePowerValues.length;
    final maxActive = activePowerValues.reduce((a, b) => a > b ? a : b);
    final maxApparent = apparentPowerValues.reduce((a, b) => a > b ? a : b);
    final maxReactive = reactivePowerValues.reduce((a, b) => a > b ? a : b);

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

  Widget _buildVoltageStats(BuildContext context) {
    final voltageValues = data.map((d) => d.voltage).toList();
    final currentValues = data.map((d) => d.current).toList();

    final avgVoltage = voltageValues.reduce((a, b) => a + b) / voltageValues.length;
    final avgCurrent = currentValues.reduce((a, b) => a + b) / currentValues.length;
    final maxVoltage = voltageValues.reduce((a, b) => a > b ? a : b);
    final maxCurrent = currentValues.reduce((a, b) => a > b ? a : b);
    final minVoltage = voltageValues.reduce((a, b) => a < b ? a : b);
    final minCurrent = currentValues.reduce((a, b) => a < b ? a : b);

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildStatsGrid({required BuildContext context, required List<Widget> items}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    
    int crossAxisCount = isTablet ? 3 : 2;
    double childAspectRatio = isTablet ? 1.3 : 1.1;
    double spacing = isTablet ? 16 : 12;

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
    final orientation = MediaQuery.of(context).orientation;

    double cardHeight;
    double iconSize;
    double labelFontSize;
    double valueFontSize;
    EdgeInsets padding;

    if (isTablet) {
      final bool isLandscape = orientation == Orientation.landscape;
      cardHeight = isLandscape ? 90 : 120;
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
        border: Border.all(color: color.withOpacity(0.2), width: 1),
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
          const SizedBox(height: 12),
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
}