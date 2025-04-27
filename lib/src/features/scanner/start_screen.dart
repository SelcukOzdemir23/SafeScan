import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF008080);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, size: 72, color: accentColor),
                const SizedBox(height: 16),
                Text(
                  'Welcome to SafeScan',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Scan, upload, or enter a URL to check its safety.',
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _StartActionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan QR Code',
                  color: accentColor,
                  onTap: () => Navigator.pushNamed(context, '/scanner'),
                ),
                const SizedBox(height: 20),
                _StartActionButton(
                  icon: Icons.image,
                  label: 'Upload QR Image',
                  color: accentColor,
                  onTap: () => Navigator.pushNamed(context, '/qr_image'),
                ),
                const SizedBox(height: 20),
                _StartActionButton(
                  icon: Icons.keyboard,
                  label: 'Enter URL Manually',
                  color: accentColor,
                  onTap: () => Navigator.pushNamed(context, '/manual_url'),
                ),
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
  final Color color;
  final VoidCallback onTap;

  const _StartActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: onTap,
      ),
    );
  }
}
