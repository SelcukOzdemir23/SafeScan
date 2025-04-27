import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';

class ResultScreen extends StatelessWidget {
  final SafetyResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSafetyIndicator()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
              const SizedBox(height: 24),
              _buildUrlCard()
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, duration: 600.ms),
              const SizedBox(height: 24),
              _buildDetailsCard()
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.2, duration: 600.ms),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildSafetyIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: result.isSafe
            ? Colors.green
                .withAlpha(25) // 0.1 opacity = 25 in alpha (255 * 0.1)
            : Colors.red.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            result.isSafe ? Icons.security : Icons.warning_rounded,
            size: 64,
            color: result.isSafe ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            result.isSafe ? 'URL Appears Safe' : 'Potential Risk Detected',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: result.isSafe ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scanned URL',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              result.url,
              style: GoogleFonts.robotoMono(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Details',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (result.threatType.isNotEmpty) ...[
              _buildDetailRow(
                'Type:',
                result.threatType,
                Icons.info_outline,
              ),
              const SizedBox(height: 12),
            ],
            _buildDetailRow(
              'Details:',
              result.description,
              Icons.description_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (result.isSafe)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(result.url),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open URL'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
