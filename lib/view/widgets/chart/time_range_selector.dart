import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeRangeSelector extends StatelessWidget {
  final String selectedTimeRange;
  final Function(String) onTimeRangeChanged;

  const TimeRangeSelector({
    super.key,
    required this.selectedTimeRange,
    required this.onTimeRangeChanged,
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
          _buildTimeRangeButton('1hour', '1H', context),
          _buildTimeRangeButton('3hours', '3H', context),
          _buildTimeRangeButton('24hours', '24H', context),
        ],
      ),
    );
  }

  Widget _buildTimeRangeButton(String value, String label, BuildContext context) {
    final isSelected = selectedTimeRange == value;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onTimeRangeChanged(value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String getTimeRangeLabel(String timeRange) {
    switch (timeRange) {
      case '1hour': return 'Last Hour';
      case '3hours': return 'Last 3 Hours';
      case '24hours': return 'Last 24 Hours';
      default: return 'Last Hour';
    }
  }
}