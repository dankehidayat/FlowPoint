import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import 'sensor_card.dart';

class PowerQualitySection extends StatelessWidget {
  final SensorData data;

  const PowerQualitySection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Power Quality', Icons.analytics_outlined, context),
        const SizedBox(height: 12),
        _buildCategoryGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          items: [
            SensorCard(
              title: 'Reactive Power',
              value: '${data.reactivePower.toStringAsFixed(1)} VAR',
              icon: Icons.auto_graph_outlined,
              color: Colors.amber,
            ),
            SensorCard(
              title: 'Power Factor',
              value: data.powerFactor.toStringAsFixed(2),
              icon: Icons.speed_outlined,
              color: Colors.teal,
            ),
            SensorCard(
              title: 'Frequency',
              value: '${data.frequency.toStringAsFixed(1)} Hz',
              icon: Icons.waves_outlined,
              color: Colors.indigo,
            ),
            SensorCard(
              title: 'Energy',
              value: '${data.energy.toStringAsFixed(1)} Wh',
              icon: Icons.energy_savings_leaf_outlined,
              color: Colors.green,
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