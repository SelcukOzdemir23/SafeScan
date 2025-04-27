import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyIndicator extends StatelessWidget {
  final bool isSafe;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const SafetyIndicator({
    super.key,
    required this.isSafe,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: (isSafe ? Colors.green : Colors.red).withAlpha(25), // 0.1 opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              (isSafe ? Colors.green : Colors.red).withAlpha(51), // 0.2 opacity
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSafe ? Icons.verified_outlined : Icons.warning_amber_rounded,
              size: 48,
              color: isSafe ? Colors.green : Colors.red,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 1.seconds,
                  begin: const Offset(1, 1),
                  end: const Offset(1.05, 1.05),
                )
                .then()
                .scale(
                  duration: 1.seconds,
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 12),
            Text(
              isSafe ? 'Safe to Visit' : 'Warning',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSafe ? Colors.green : Colors.red,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(179), // 0.7 opacity
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onAction,
                icon: Icon(
                  isSafe ? Icons.open_in_new : Icons.refresh,
                  size: 18,
                ),
                label: Text(actionLabel!),
              ).animate().fadeIn(delay: 400.ms),
            ],
          ],
        ),
      ),
    );
  }
}
