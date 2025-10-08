// lib/views/widgets/dashboard/gauge_environment_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GaugeEnvironmentCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool isTabletLandscape;
  final double screenHeight;

  const GaugeEnvironmentCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.isTabletLandscape,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final bool isLargeTablet = screenWidth >= 900;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final Color backgroundColor = isDark 
        ? _getDarkModeColor(color).withOpacity(0.15)
        : color.withOpacity(0.1);
    
    final Color iconBackgroundColor = isDark
        ? _getDarkModeColor(color).withOpacity(0.25)
        : color.withOpacity(0.15);
    
    final Color borderColor = isDark
        ? Colors.transparent
        : color.withOpacity(0.2);
    
    final Color displayColor = isDark 
        ? _getDarkModeColor(color)
        : color;

    // Determine current value color and range
    final GaugeRange currentRange = _getGaugeRange(title, value);
    final Color valueColor = currentRange.color;

    // FIXED: Correct percentage calculation for gauge positioning
    final double percentage = _calculateCorrectPercentage(title, value);

    // Get gauge ranges for background
    final List<GaugeSegment> segments = _getGaugeSegments(title);

    // Sizing - Optimized for mobile to prevent overflow
    double labelFontSize;
    double valueFontSize;
    double iconSize;
    double gaugeHeight;
    double gaugeWidth;
    double cardHeight;

    if (isLargeTablet) {
      labelFontSize = isTabletLandscape ? 20 : 22;
      valueFontSize = isTabletLandscape ? 28 : 32;
      iconSize = isTabletLandscape ? 32 : 36;
      gaugeHeight = isTabletLandscape ? 180 : 200;
      gaugeWidth = isTabletLandscape ? 40 : 45;
      cardHeight = isTabletLandscape ? 240 : 260;
    } else if (isTablet) {
      labelFontSize = isTabletLandscape ? 16 : 18;
      valueFontSize = isTabletLandscape ? 22 : 26;
      iconSize = isTabletLandscape ? 28 : 32;
      gaugeHeight = isTabletLandscape ? 140 : 160;
      gaugeWidth = isTabletLandscape ? 32 : 36;
      cardHeight = isTabletLandscape ? 200 : 220;
    } else {
      final bool isTallScreen = screenHeight > 700;
      labelFontSize = isTabletLandscape ? 12 : 14;
      valueFontSize = isTabletLandscape ? 16 : 18;
      iconSize = isTabletLandscape ? 20 : 22;
      gaugeHeight = isTabletLandscape ? 100 : 120;
      gaugeWidth = isTabletLandscape ? 24 : 28;
      cardHeight = isTallScreen ? 160 : 140;
    }

    return Container(
      constraints: isTabletLandscape 
          ? BoxConstraints(
              minWidth: isLargeTablet ? 180 : 160,
              maxWidth: isLargeTablet ? 260 : 240,
              minHeight: isTablet ? (isLargeTablet ? 200 : 180) : 120,
              maxHeight: isTablet ? (isLargeTablet ? 220 : 200) : 140,
            )
          : BoxConstraints(
              minWidth: isLargeTablet ? 200 : (isTablet ? 180 : 150),
              maxWidth: isLargeTablet ? 360 : (isTablet ? 340 : 280),
              minHeight: isTablet ? (isLargeTablet ? 240 : 200) : cardHeight,
              maxHeight: isTablet ? (isLargeTablet ? 260 : 220) : cardHeight,
            ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: isTabletLandscape 
            ? EdgeInsets.symmetric(
                horizontal: isLargeTablet ? 20 : 16, 
                vertical: isTablet ? (isLargeTablet ? 20 : 16) : 8
              )
            : EdgeInsets.symmetric(
                horizontal: isLargeTablet ? 24 : (isTablet ? 20 : 14),
                vertical: isTablet ? (isLargeTablet ? 24 : 20) : 12
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isLargeTablet ? 12 : (isTablet ? 10 : 8)),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon, 
                    size: iconSize,
                    color: displayColor
                  ),
                ),
                SizedBox(width: isLargeTablet ? 16 : (isTablet ? 12 : 8)),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isLargeTablet ? 16 : (isTablet ? 12 : 8)),
            
            // Gauge and value display
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Custom Gauge
                  Container(
                    width: gaugeWidth,
                    height: gaugeHeight,
                    margin: EdgeInsets.symmetric(horizontal: isLargeTablet ? 8 : (isTablet ? 6 : 4)),
                    child: Stack(
                      children: [
                        // Background track with gradient segments
                        Container(
                          width: gaugeWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(isLargeTablet ? 12 : 10),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: segments.map((segment) => segment.color).toList(),
                              stops: segments.map((segment) => segment.position).toList(),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        // Fill indicator
                        Align(
                          alignment: Alignment(0, (percentage * 2 - 1)),
                          child: Container(
                            width: gaugeWidth + (isLargeTablet ? 10 : 8),
                            height: isLargeTablet ? 5 : 4,
                            decoration: BoxDecoration(
                              color: valueColor,
                              borderRadius: BorderRadius.circular(isLargeTablet ? 3 : 2),
                              boxShadow: [
                                BoxShadow(
                                  color: valueColor.withOpacity(0.6),
                                  blurRadius: 6,
                                  spreadRadius: isLargeTablet ? 2 : 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Current value indicator (circle) - FIXED POSITIONING
                        Align(
                          alignment: Alignment(0, (percentage * 2 - 1)),
                          child: Container(
                            width: gaugeWidth + (isLargeTablet ? 14 : 12),
                            height: gaugeWidth + (isLargeTablet ? 14 : 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: valueColor,
                                width: isLargeTablet ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: isLargeTablet ? 8 : 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: isLargeTablet ? 8 : 6,
                                height: isLargeTablet ? 8 : 6,
                                decoration: BoxDecoration(
                                  color: valueColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: isLargeTablet ? 16 : (isTablet ? 12 : 8)),
                  
                  // Value display
                  Container(
                    width: isLargeTablet ? 120 : (isTablet ? 100 : 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Value and unit on the same line
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              value.toStringAsFixed(1),
                              style: GoogleFonts.lato(
                                fontSize: valueFontSize * (isLargeTablet ? 1.4 : 1.3),
                                fontWeight: FontWeight.bold,
                                color: valueColor,
                              ),
                            ),
                            SizedBox(width: isLargeTablet ? 4 : 2),
                            Text(
                              unit,
                              style: GoogleFonts.lato(
                                fontSize: valueFontSize * (isLargeTablet ? 0.9 : 0.8),
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isLargeTablet ? 12 : (isTablet ? 8 : 6)),
                        // Range indicator
                        _buildRangeIndicator(context, currentRange, isTablet, isLargeTablet),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeIndicator(BuildContext context, GaugeRange range, bool isTablet, bool isLargeTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeTablet ? 12 : (isTablet ? 8 : 6), 
        vertical: isLargeTablet ? 6 : (isTablet ? 4 : 3)
      ),
      decoration: BoxDecoration(
        color: range.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isLargeTablet ? 12 : 10),
        border: Border.all(
          color: range.color.withOpacity(0.3),
          width: isLargeTablet ? 1.5 : 1,
        ),
      ),
      child: Text(
        range.label,
        style: GoogleFonts.lato(
          fontSize: isLargeTablet ? 12 : (isTablet ? 10 : 9),
          fontWeight: FontWeight.bold,
          color: range.color,
        ),
      ),
    );
  }

  List<GaugeSegment> _getGaugeSegments(String title) {
    if (title.toLowerCase().contains('temp')) {
      return [
        GaugeSegment(Colors.blue.shade300, 0.0),    // 0°C - Cold
        GaugeSegment(Colors.blue.shade200, 0.25),   // 0-18°C transition
        GaugeSegment(Colors.green.shade400, 0.35),  // 18°C - Normal start
        GaugeSegment(Colors.green.shade300, 0.55),  // 18-28°C transition  
        GaugeSegment(Colors.red.shade400, 0.75),    // 28°C - Hot start
        GaugeSegment(Colors.red.shade300, 1.0),     // 50°C - Hot
      ];
    } else {
      // Humidity gauge segments - INVERTED: Blue at bottom, Orange at top
      return [
        GaugeSegment(Colors.blue.shade300, 0.0),    // 0% - Humid (bottom)
        GaugeSegment(Colors.blue.shade200, 0.2),    // 0-30% transition
        GaugeSegment(Colors.green.shade400, 0.3),   // 30% - Normal start
        GaugeSegment(Colors.green.shade300, 0.6),   // 30-70% transition
        GaugeSegment(Colors.orange.shade400, 0.8),  // 70% - Dry start
        GaugeSegment(Colors.orange.shade300, 1.0),  // 100% - Dry (top)
      ];
    }
  }

  // FIXED: Correct percentage calculation for gauge positioning
  double _calculateCorrectPercentage(String title, double value) {
    if (title.toLowerCase().contains('temp')) {
      // Temperature range: 0-50°C
      return (value / 50.0).clamp(0.0, 1.0);
    } else {
      // Humidity range: 0-100%
      return (value / 100.0).clamp(0.0, 1.0);
    }
  }

  // FIXED: Improved gauge range detection with proper colors
  GaugeRange _getGaugeRange(String title, double value) {
    if (title.toLowerCase().contains('temp')) {
      if (value < 18) {
        return GaugeRange('COLD', Colors.blue.shade400);
      } else if (value > 28) {
        return GaugeRange('HOT', Colors.red.shade400);
      } else {
        return GaugeRange('NORMAL', Colors.green.shade400);
      }
    } else {
      // Humidity ranges - Colors updated to match inverted gauge
      if (value < 30) {
        return GaugeRange('DRY', Colors.orange.shade400); // Now orange for dry
      } else if (value > 70) {
        return GaugeRange('HUMID', Colors.blue.shade400); // Now blue for humid
      } else {
        return GaugeRange('NORMAL', Colors.green.shade400);
      }
    }
  }

  Color _getDarkModeColor(Color lightColor) {
    if (lightColor == Colors.red) return Colors.red.shade300;
    if (lightColor == Colors.blue) return Colors.blue.shade300;
    if (lightColor == Colors.orange) return Colors.orange.shade300;
    if (lightColor == Colors.green) return Colors.green.shade300;
    return lightColor;
  }
}

class GaugeSegment {
  final Color color;
  final double position;

  GaugeSegment(this.color, this.position);
}

class GaugeRange {
  final String label;
  final Color color;

  GaugeRange(this.label, this.color);
}