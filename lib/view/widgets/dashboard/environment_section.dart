// lib/views/widgets/dashboard/environment_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../models/sensor_data.dart';
import 'environment_card.dart';
import 'gauge_environment_card.dart';

class EnvironmentSection extends StatelessWidget {
  final SensorData data;

  const EnvironmentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;
    final bool isDesktop = screenWidth >= 1024;
    final bool isTabletLandscape = isTablet && screenWidth > screenHeight;
    
    // Use try-catch to handle provider not found, with a default value
    bool useGaugeView;
    Color temperatureColor;
    Color humidityColor;
    
    try {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
      useGaugeView = settingsProvider.useGaugeView;
      temperatureColor = settingsProvider.getTemperatureColor(data.temperature);
      humidityColor = settingsProvider.getHumidityColor(data.humidity);
    } catch (e) {
      // Fallback values if provider is not available
      useGaugeView = false;
      temperatureColor = _getFallbackTemperatureColor(data.temperature);
      humidityColor = _getFallbackHumidityColor(data.humidity);
    }

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
          useGaugeView: useGaugeView,
          screenHeight: screenHeight,
          items: useGaugeView 
              ? [
                  GaugeEnvironmentCard(
                    title: 'Temperature',
                    value: data.temperature,
                    unit: '°C',
                    icon: Icons.thermostat_outlined,
                    color: temperatureColor,
                    isTabletLandscape: isTabletLandscape,
                    screenHeight: screenHeight,
                  ),
                  GaugeEnvironmentCard(
                    title: 'Humidity',
                    value: data.humidity,
                    unit: '%',
                    icon: Icons.water_drop_outlined,
                    color: humidityColor,
                    isTabletLandscape: isTabletLandscape,
                    screenHeight: screenHeight,
                  ),
                ]
              : [
                  EnvironmentCard(
                    title: 'Temperature',
                    value: '${data.temperature.toStringAsFixed(1)}°C',
                    icon: Icons.thermostat_outlined,
                    color: temperatureColor,
                    isTabletLandscape: isTabletLandscape,
                    screenHeight: screenHeight,
                  ),
                  EnvironmentCard(
                    title: 'Humidity',
                    value: '${data.humidity.toStringAsFixed(1)}%',
                    icon: Icons.water_drop_outlined,
                    color: humidityColor,
                    isTabletLandscape: isTabletLandscape,
                    screenHeight: screenHeight,
                  ),
                ],
        ),
      ],
    );
  }

  Color _getFallbackTemperatureColor(double temperature) {
    if (temperature < 18) return Colors.blue;
    if (temperature > 28) return Colors.red;
    return Colors.green;
  }

  Color _getFallbackHumidityColor(double humidity) {
    if (humidity < 30) return Colors.orange;
    if (humidity > 70) return Colors.blue;
    return Colors.green;
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
    required bool useGaugeView,
    required double screenHeight,
    required List<Widget> items,
  }) {
    int crossAxisCount;
    double childAspectRatio;

    if (isDesktop) {
      crossAxisCount = 2;
      childAspectRatio = useGaugeView ? 1.6 : 2.2;
    } else if (isTablet) {
      if (isTabletLandscape) {
        crossAxisCount = 2;
        childAspectRatio = useGaugeView ? 1.3 : 1.6;
      } else {
        crossAxisCount = 2;
        childAspectRatio = useGaugeView ? 1.4 : 1.8;
      }
    } else {
      crossAxisCount = 2;
      final bool isTallScreen = screenHeight > 700;
      childAspectRatio = useGaugeView 
          ? (isTallScreen ? 1.0 : 0.9)
          : (isTallScreen ? 1.4 : 1.2);
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