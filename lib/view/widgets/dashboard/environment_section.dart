import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/sensor_data.dart';
import 'environment_card.dart';

class EnvironmentSection extends StatelessWidget {
  final SensorData data;

  const EnvironmentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTabletLandscape = isTablet && screenWidth > MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Environment', Icons.thermostat_outlined, context),
        const SizedBox(height: 12),
        _buildEnvironmentGrid(
          context: context,
          isTablet: isTablet,
          isDesktop: isDesktop,
          isTabletLandscape: isTabletLandscape,
          items: [
            EnvironmentCard(
              title: 'Temperature',
              value: '${data.temperature.toStringAsFixed(1)}°C',
              icon: Icons.thermostat_outlined,
              color: Colors.red,
              isTabletLandscape: isTabletLandscape,
            ),
            EnvironmentCard(
              title: 'Humidity',
              value: '${data.humidity.toStringAsFixed(1)}%',
              icon: Icons.water_drop_outlined,
              color: Colors.blue,
              isTabletLandscape: isTabletLandscape,
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

  Widget _buildEnvironmentGrid({
    required BuildContext context,
    required bool isTablet,
    required bool isDesktop,
    required bool isTabletLandscape,
    required List<Widget> items,
  }) {
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 2;
      childAspectRatio = 2.5;
    } else if (isTablet) {
      if (isTabletLandscape) {
        crossAxisCount = 2;
        childAspectRatio = 1.8;
      } else {
        crossAxisCount = 2;
        childAspectRatio = 2.5;
      }
    } else {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
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