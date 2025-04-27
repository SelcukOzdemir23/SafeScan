import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ActionSelectionSheet extends StatelessWidget {
  final VoidCallback onScanQr;
  final VoidCallback onUploadImage;
  final VoidCallback onEnterUrl;

  const ActionSelectionSheet({
    super.key,
    required this.onScanQr,
    required this.onUploadImage,
    required this.onEnterUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withAlpha(60),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Choose an Option',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 8),
              Text(
                'Select how you want to check a URL',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

              const SizedBox(height: 24),

              // Action buttons
              _ActionButton(
                icon: MdiIcons.qrcodeScan,
                label: 'Scan QR Code',
                description: 'Use camera to scan a QR code',
                onTap: () {
                  Navigator.pop(context);
                  onScanQr();
                },
              ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    delay: 200.ms,
                    duration: 300.ms,
                    curve: Curves.easeOutQuad,
                  ),

              const Divider(height: 1),

              _ActionButton(
                icon: MdiIcons.imageMultiple,
                label: 'Upload QR Image',
                description: 'Select an image from your gallery',
                onTap: () {
                  Navigator.pop(context);
                  onUploadImage();
                },
              ).animate().fadeIn(delay: 300.ms, duration: 300.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    delay: 300.ms,
                    duration: 300.ms,
                    curve: Curves.easeOutQuad,
                  ),

              const Divider(height: 1),

              _ActionButton(
                icon: MdiIcons.keyboardOutline,
                label: 'Enter URL Manually',
                description: 'Type or paste a URL to check',
                onTap: () {
                  Navigator.pop(context);
                  onEnterUrl();
                },
              ).animate().fadeIn(delay: 400.ms, duration: 300.ms).slideX(
                    begin: -0.1,
                    end: 0,
                    delay: 400.ms,
                    duration: 300.ms,
                    curve: Curves.easeOutQuad,
                  ),

              const SizedBox(height: 16),

              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ],
        ),
      ),
    );
  }
}
