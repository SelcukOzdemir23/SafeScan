import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo with animation
                Icon(
                  Icons.shield_rounded,
                  size: 80,
                  color: colorScheme.primary,
                )
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .scale(
                      duration: 3.seconds,
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      curve: Curves.easeInOut,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideY(
                        begin: -0.1,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut),

                const SizedBox(height: 24),

                // App title with animation
                Text(
                  'SafeScan QR',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 800.ms, delay: 300.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 800.ms,
                    delay: 300.ms,
                    curve: Curves.easeOutQuad),

                const SizedBox(height: 12),

                // App description with animation
                Text(
                  'Scan QR codes and verify URL safety before visiting',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withAlpha(180),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 800.ms, delay: 500.ms).slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 800.ms,
                    delay: 500.ms,
                    curve: Curves.easeOutQuad),

                const SizedBox(height: 48),

                // Action buttons with animations
                _StartActionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan QR Code',
                  description: 'Use camera to scan',
                  onTap: () => Navigator.pushNamed(context, '/scanner'),
                ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(
                    begin: 0.2, end: 0, duration: 600.ms, delay: 700.ms),

                const SizedBox(height: 16),

                _StartActionButton(
                  icon: Icons.image_outlined,
                  label: 'Upload QR Image',
                  description: 'From your gallery',
                  onTap: () => Navigator.pushNamed(context, '/qr_image'),
                ).animate().fadeIn(duration: 600.ms, delay: 900.ms).slideY(
                    begin: 0.2, end: 0, duration: 600.ms, delay: 900.ms),

                const SizedBox(height: 16),

                _StartActionButton(
                  icon: Icons.keyboard_alt_outlined,
                  label: 'Enter URL Manually',
                  description: 'Type or paste a link',
                  onTap: () => Navigator.pushNamed(context, '/manual_url'),
                ).animate().fadeIn(duration: 600.ms, delay: 1100.ms).slideY(
                    begin: 0.2, end: 0, duration: 600.ms, delay: 1100.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _StartActionButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(40),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: colorScheme.primary.withAlpha(40),
        highlightColor: colorScheme.primary.withAlpha(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
                  size: 24,
                  color: colorScheme.primary,
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
      ),
    );
  }
}
