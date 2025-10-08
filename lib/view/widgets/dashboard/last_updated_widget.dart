import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/sensor_provider.dart';
import '../../../models/sensor_data.dart';

class LastUpdatedWidget extends StatelessWidget {
  final SensorData data;
  final SensorProvider sensorProvider;

  const LastUpdatedWidget({
    super.key,
    required this.data,
    required this.sensorProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isRecent = DateTime.now().difference(data.timestamp).inSeconds < 10;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: data.isOnline 
                  ? (isRecent ? Colors.green : Colors.orange)
                  : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                data.isOnline 
                  ? (isRecent ? 'Online | Good' : 'Online | Delayed')
                  : 'Offline',
                style: GoogleFonts.lato(
                  color: data.isOnline 
                    ? (isRecent ? Colors.green : Colors.orange)
                    : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: ${_formatTime(data.timestamp)}',
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            'Data points: ${sensorProvider.sensorHistory.length}',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}