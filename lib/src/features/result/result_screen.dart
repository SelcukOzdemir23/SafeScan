import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/widgets/safety_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class ResultScreen extends StatelessWidget {
  final SafetyCheckResult result;

  const ResultScreen({super.key, required this.result});

  // Function to attempt opening the URL
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       // Show error if launching failed
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Could not launch $urlString')),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isSafeToOpen = result.status == SafetyStatus.safe || result.status == SafetyStatus.unknown; // Allow opening unknown for now

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Safety Indicator Widget
              SafetyIndicator(status: result.status),
              const SizedBox(height: 24),

              // Status Text
              Text(
                result.status.displayName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: result.status.color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Display the Scanned URL
              Text(
                'URL:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                result.url,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Action Button (Open or just info)
              if (result.status != SafetyStatus.error) // Don't show open button on error
                ElevatedButton.icon(
                   icon: Icon(isSafeToOpen ? Icons.open_in_browser : Icons.warning_amber_rounded),
                   label: Text(isSafeToOpen ? 'Open URL Safely' : 'Do Not Open'),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: isSafeToOpen ? theme.colorScheme.primary : theme.colorScheme.errorContainer,
                     foregroundColor: isSafeToOpen ? theme.colorScheme.onPrimary : theme.colorScheme.onErrorContainer,
                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                     textStyle: theme.textTheme.labelLarge,
                   ),
                   onPressed: isSafeToOpen
                       ? () => _launchURL(context, result.url)
                       : null, // Disable button if not safe/unknown
                 ),

              const Spacer(), // Push disclaimer to bottom

              // Disclaimer
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Text(
                   'Disclaimer: URL safety checks are not foolproof. Always exercise caution when opening links, especially from unknown sources. SafeScan provides an indication based on available data but cannot guarantee 100% safety.',
                   style: theme.textTheme.bodySmall?.copyWith(
                     color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                   ),
                   textAlign: TextAlign.center,
                 ),
               ),
              const SizedBox(height: 16), // Padding at the bottom

              // Back Button
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Scan Another QR Code'),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
