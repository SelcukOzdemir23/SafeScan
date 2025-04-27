import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/config/app_theme.dart';

class PermissionMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PermissionMessage({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.camera_alt_outlined, // Camera icon
              size: 60,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 20),
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Grant Permission'),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  // Use theme accent color
                  // backgroundColor: AppTheme.accentColor,
                  // foregroundColor: AppTheme.primaryColor,
                  ),
            ),
            // Optional: Add button to open app settings
             const SizedBox(height: 12),
             TextButton(
               child: const Text('Open Settings'),
               onPressed: () async {
                  // Consider using the permission_handler's openAppSettings()
                  // Example: await openAppSettings();
                  print("Placeholder: Would open app settings");
               },
             ),
          ],
        ),
      ),
    );
  }
}
