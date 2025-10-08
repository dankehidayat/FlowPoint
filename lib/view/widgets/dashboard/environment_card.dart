// lib/views/widgets/dashboard/environment_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvironmentCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isTabletLandscape;
  final double screenHeight;

  const EnvironmentCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isTabletLandscape,
    required this.screenHeight, // Add this parameter
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

    // Special font sizes - Reduced for mobile
    double labelFontSize;
    double valueFontSize;
    double iconSize;

    if (isLargeTablet) {
      labelFontSize = isTabletLandscape ? 20 : 22;
      valueFontSize = isTabletLandscape ? 42 : 46;
      iconSize = isTabletLandscape ? 36 : 40;
    } else if (isTablet) {
      labelFontSize = isTabletLandscape ? 16 : 18;
      valueFontSize = isTabletLandscape ? 36 : 40;
      iconSize = isTabletLandscape ? 32 : 36;
    } else {
      // Mobile - Reduced sizes
      final bool isTallScreen = screenHeight > 700;
      labelFontSize = isTabletLandscape ? 12 : 14;
      valueFontSize = isTabletLandscape ? 20 : 24;
      iconSize = isTabletLandscape ? 22 : 26;
    }

    return Container(
      constraints: isTabletLandscape 
          ? BoxConstraints(
              minWidth: isLargeTablet ? 160 : 140,
              maxWidth: isLargeTablet ? 220 : 200,
              minHeight: isTablet ? (isLargeTablet ? 140 : 130) : 80,
              maxHeight: isTablet ? (isLargeTablet ? 160 : 150) : 100,
            )
          : BoxConstraints(
              minWidth: isLargeTablet ? 180 : (isTablet ? 160 : 140),
              maxWidth: isLargeTablet ? 300 : (isTablet ? 280 : 240),
              minHeight: isTablet ? (isLargeTablet ? 160 : 150) : 100,
              maxHeight: isTablet ? (isLargeTablet ? 180 : 170) : 120,
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
                horizontal: isLargeTablet ? 16 : 12, 
                vertical: isTablet ? (isLargeTablet ? 20 : 16) : 8
              )
            : EdgeInsets.symmetric(
                horizontal: isLargeTablet ? 20 : (isTablet ? 16 : 12),
                vertical: isTablet ? (isLargeTablet ? 24 : 20) : 12
              ),
        child: Row(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: valueFontSize,
                      fontWeight: FontWeight.bold,
                      color: displayColor,
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

  Color _getDarkModeColor(Color lightColor) {
    if (lightColor == Colors.red) return Colors.red.shade300;
    if (lightColor == Colors.blue) return Colors.blue.shade300;
    return lightColor;
  }
}