import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnvironmentCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isTabletLandscape;

  const EnvironmentCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isTabletLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
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

    // Special font sizes for temperature and humidity cards
    double labelFontSize;
    double valueFontSize;
    double iconSize;

    if (isTablet) {
      // Tablet: Very large fonts for temperature and humidity
      labelFontSize = isTabletLandscape ? 18 : 20;
      valueFontSize = 42; // Very big font size for tablet temperature/humidity values
      iconSize = isTabletLandscape ? 32 : 36;
    } else {
      // Mobile: Normal sizes but bold labels
      labelFontSize = isTabletLandscape ? 12 : 14;
      valueFontSize = isTabletLandscape ? 14 : 16;
      iconSize = isTabletLandscape ? 20 : 24;
    }

    return Container(
      constraints: isTabletLandscape 
          ? BoxConstraints(
              minWidth: 100,
              maxWidth: 180,
              minHeight: isTablet ? 120 : 50,
              maxHeight: isTablet ? 140 : 65,
            )
          : BoxConstraints(
              minWidth: 120,
              maxWidth: 300,
              minHeight: isTablet ? 140 : 60,
              maxHeight: isTablet ? 160 : 80,
            ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
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
            ? EdgeInsets.symmetric(horizontal: 16, vertical: isTablet ? 20 : 8)
            : EdgeInsets.symmetric(horizontal: 20, vertical: isTablet ? 24 : 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : (isTabletLandscape ? 6 : 8)),
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
            SizedBox(width: isTablet ? 16 : (isTabletLandscape ? 10 : 12)),
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
                      color: color,
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