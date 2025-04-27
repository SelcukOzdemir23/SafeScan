import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safescan_flutter/src/utils/constants.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
    // Register error handler
    FlutterError.onError = _handleFlutterError;
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    if (mounted) {
      setState(() {
        _error = details;
      });
    }
    // Log the error (you can implement proper logging here)
    debugPrint('Error caught by ErrorBoundary: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  }

  void _resetError() {
    if (mounted) {
      setState(() {
        _error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _defaultErrorWidget(context);
    }

    return widget.child;
  }

  Widget _defaultErrorWidget(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: AppConstants.largeIconSize,
                  color: Theme.of(context).colorScheme.error,
                )
                    .animate()
                    .scale(duration: 400.ms)
                    .then()
                    .shake(duration: 400.ms),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 12),
                Text(
                  'The app encountered an unexpected error. Please try again.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .errorContainer
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.errorContainer,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _error!.exception.toString(),
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _resetError,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset the error handler to avoid memory leaks
    FlutterError.onError = FlutterError.presentError;
    super.dispose();
  }
}
