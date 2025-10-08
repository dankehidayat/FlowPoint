import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusCard extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const StatusCard({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connection Issue',
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error,
                    style: GoogleFonts.lato(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              onPressed: onRetry,
              tooltip: 'Retry Connection',
            ),
          ],
        ),
      ),
    );
  }
}