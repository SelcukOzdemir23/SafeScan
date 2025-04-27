import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final accentColor = const Color(0xFF008080);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'What would you like to do?',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan QR',
                  color: accentColor,
                  onTap: () {
                    Navigator.pop(context);
                    onScanQr();
                  },
                ),
                _ActionButton(
                  icon: Icons.image,
                  label: 'Upload Image',
                  color: accentColor,
                  onTap: () {
                    Navigator.pop(context);
                    onUploadImage();
                  },
                ),
                _ActionButton(
                  icon: Icons.keyboard,
                  label: 'Enter URL',
                  color: accentColor,
                  onTap: () {
                    Navigator.pop(context);
                    onEnterUrl();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
