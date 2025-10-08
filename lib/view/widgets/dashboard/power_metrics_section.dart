import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import 'sensor_card.dart';

class PowerMetricsSection extends StatelessWidget {
  final SensorData data;

  const PowerMetricsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Power Metrics', Icons.bolt_outlined, context),
        const SizedBox(height: 12),
        _buildCategoryGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          items: [
            SensorCard(
              title: 'Voltage',
              value: '${data.voltage.toStringAsFixed(1)} V',
              icon: Icons.offline_bolt_outlined,
              color: Colors.orange,
            ),
            SensorCard(
              title: 'Current',
              value: '${data.current.toStringAsFixed(2)} A',
              icon: Icons.electric_bolt_outlined,
              color: Colors.blue,
            ),
            SensorCard(
              title: 'Active Power',
              value: '${data.power.toStringAsFixed(1)} W',
              icon: Icons.power_outlined,
              color: Colors.red,
            ),
            SensorCard(
              title: 'Apparent Power',
              value: '${data.apparentPower.toStringAsFixed(1)} VA',
              icon: Icons.offline_bolt_outlined,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid({
    required BuildContext context,
    required bool isTablet,
    required bool isDesktop,
    required List<Widget> items,
  }) {
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 4;
      childAspectRatio = 2.5;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 2.5;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    }

    if (items.length < crossAxisCount) {
      crossAxisCount = items.length;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: items,
    );
  }
}