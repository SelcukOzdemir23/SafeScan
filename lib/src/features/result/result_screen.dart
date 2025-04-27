
import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/widgets/safety_indicator.dart';
import 'package:url_launcher/url_launcher.dart';


class ResultScreen extends StatefulWidget {
  final String scannedUrl;

  const ResultScreen({super.key, required this.scannedUrl});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<SafetyResult> _safetyCheckFuture;
  final UrlSafetyService _safetyService = UrlSafetyService(); // Use instance

  @override
  void initState() {
    super.initState();
    _safetyCheckFuture = _safetyService.checkUrlSafety(widget.scannedUrl);
  }

   Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Check Result'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Center(
        child: FutureBuilder<SafetyResult>(
          future: _safetyCheckFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     const Icon(Icons.error_outline, color: Colors.red, size: 60),
                     const SizedBox(height: 16),
                     Text(
                        'Error Checking URL',
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                     const SizedBox(height: 8),
                     Text(
                       'Could not determine the safety status of the URL. Please check your connection or try again later.',
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'URL: ${widget.scannedUrl}',
                         style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                         textAlign: TextAlign.center,
                       ),
                       const SizedBox(height: 24),
                       ElevatedButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text('Scan Again'),
                       ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final result = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafetyIndicator(status: result.status),
                    const SizedBox(height: 24),
                    Text(
                      result.status.displayName,
                      style: textTheme.headlineMedium?.copyWith(
                        color: result.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result.message, // Display message from backend
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Scanned URL:',
                       style: textTheme.labelLarge?.copyWith(color: Colors.grey[700]),
                     ),
                    const SizedBox(height: 4),
                    SelectableText(
                      widget.scannedUrl,
                      style: textTheme.bodyMedium?.copyWith(decoration: TextDecoration.underline, color: Colors.blue),
                      textAlign: TextAlign.center,
                      onTap: () => _launchUrl(widget.scannedUrl), // Allow opening if desired
                    ),
                    const SizedBox(height: 32),
                    // Optional Disclaimer
                    Text(
                      'Disclaimer: Safety checks are based on available data and may not be 100% accurate. Exercise caution when visiting unknown links.',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                     const SizedBox(height: 24),
                     ElevatedButton(
                       onPressed: () => Navigator.pop(context),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                       ),
                       child: const Text('Scan Another QR Code'),
                     ),
                  ],
                ),
              );
            } else {
              // Should not happen in normal flow with FutureBuilder
              return const Text('No result data found.');
            }
          },
        ),
      ),
    );
  }
}
