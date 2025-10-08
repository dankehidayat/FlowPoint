import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartLegend extends StatelessWidget {
  final String chartType;

  const ChartLegend({super.key, required this.chartType});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _getLegendItems(),
    );
  }

  List<Widget> _getLegendItems() {
    switch (chartType) {
      case 'temperature':
        return [
          _buildLegendItem('Temperature', Colors.red),
          const SizedBox(width: 20),
          _buildLegendItem('Humidity', Colors.blue),
        ];
      
      case 'power':
        return [
          _buildLegendItem('Active Power', Colors.green),
          const SizedBox(width: 20),
          _buildLegendItem('Apparent Power', Colors.orange),
          const SizedBox(width: 20),
          _buildLegendItem('Reactive Power', Colors.purple),
        ];
      
      case 'voltage':
        return [
          _buildLegendItem('Voltage', Colors.amber),
          const SizedBox(width: 20),
          _buildLegendItem('Current', Colors.cyan),
        ];
      
      default: return [];
    }
  }

  Widget _buildLegendItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}