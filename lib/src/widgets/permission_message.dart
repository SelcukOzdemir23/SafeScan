import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:safescan_flutter/src/utils/constants.dart';

class PermissionMessage extends StatelessWidget {
  final PermissionStatus status;
  final VoidCallback onRequestPermission;

  const PermissionMessage({
    super.key,
    required this.status,
    required this.onRequestPermission,
  });

  String get _message {
    switch (status) {
      case PermissionStatus.denied:
        return AppConstants.cameraPermissionMessage;
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return 'Camera access is permanently denied. Please enable it in your device settings to use the QR scanner.';
      case PermissionStatus.limited:
        return 'Limited camera access granted. Full access is needed for the QR scanner to work properly.';
      default:
        return AppConstants.cameraPermissionMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: AppConstants.largeIconSize,
              color: Theme.of(context).colorScheme.primary,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: AppConstants.longAnimation,
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                )
                .then()
                .scale(
                  duration: AppConstants.longAnimation,
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                ),
            const SizedBox(height: 24),
            Text(
              AppConstants.cameraPermissionTitle,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3),
            const SizedBox(height: 12),
            Text(
              _message,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(179), // 0.7 opacity
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: 32),
            if (status.isPermanentlyDenied || status.isRestricted)
              ElevatedButton.icon(
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2)
            else
              ElevatedButton.icon(
                onPressed: onRequestPermission,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Grant Camera Access'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
