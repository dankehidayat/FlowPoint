import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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

    // Font sizes for tablet
    double labelFontSize = isTablet ? 16 : 12;
    double valueFontSize = isTablet ? 20 : 14;
    double iconSize = isTablet ? 28 : 20;

    return Container(
      constraints: BoxConstraints(
        minWidth: 120,
        maxWidth: 300,
        minHeight: isTablet ? 80 : 60,
        maxHeight: isTablet ? 100 : 80,
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
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16, vertical: isTablet ? 16 : 12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 8 : 6),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: displayColor),
            ),
            SizedBox(width: isTablet ? 16 : 12),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDarkModeColor(Color lightColor) {
    if (lightColor == Colors.orange) return Colors.orange.shade300;
    if (lightColor == Colors.blue) return Colors.blue.shade300;
    if (lightColor == Colors.red) return Colors.red.shade300;
    if (lightColor == Colors.purple) return Colors.purple.shade300;
    if (lightColor == Colors.green) return Colors.green.shade300;
    if (lightColor == Colors.teal) return Colors.teal.shade300;
    if (lightColor == Colors.indigo) return Colors.indigo.shade300;
    if (lightColor == Colors.amber) return Colors.amber.shade300;
    return lightColor;
  }
}