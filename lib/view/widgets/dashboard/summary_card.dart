import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';

class SummaryCard extends StatelessWidget {
  final SensorData data;

  const SummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Summary',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Energy', '${data.energy.toStringAsFixed(1)} Wh', 
                    Icons.energy_savings_leaf_outlined, context),
                _buildSummaryItem('Temp', '${data.temperature.toStringAsFixed(1)}°C', 
                    Icons.thermostat_outlined, context),
                _buildSummaryItem('Humid', '${data.humidity.toStringAsFixed(1)}%', 
                    Icons.water_drop_outlined, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    double labelFontSize = isTablet ? 14 : 12;
    double valueFontSize = isTablet ? 18 : 14;
    double iconSize = isTablet ? 24 : 18;

    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: valueFontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}