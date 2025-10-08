import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartTypeSelector extends StatelessWidget {
  final String selectedChartType;
  final Function(String) onChartTypeChanged;

  const ChartTypeSelector({
    super.key,
    required this.selectedChartType,
    required this.onChartTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildChartTypeButton('temperature', Icons.thermostat_outlined, context),
          _buildChartTypeButton('power', Icons.bolt_outlined, context),
          _buildChartTypeButton('voltage', Icons.offline_bolt_outlined, context),
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String value, IconData icon, BuildContext context) {
    final isSelected = selectedChartType == value;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onChartTypeChanged(value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 28,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}