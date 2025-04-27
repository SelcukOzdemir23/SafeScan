import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safescan_flutter/src/services/qr_image_service.dart';
import 'package:safescan_flutter/src/utils/constants.dart';
import 'package:safescan_flutter/src/widgets/error_message.dart';

class QrImagePage extends StatefulWidget {
  const QrImagePage({super.key});

  @override
  State<QrImagePage> createState() => _QrImagePageState();
}

class _QrImagePageState extends State<QrImagePage> {
  bool _isProcessing = false;
  String? _error;
  final QrImageService _qrImageService = QrImageService();

  Future<void> _pickAndProcessImage() async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }
      final String? qrData =
          await _qrImageService.processQrImage(File(image.path));
      if (qrData == null) {
        setState(() {
          _isProcessing = false;
          _error = 'No valid QR code found in the image.';
        });
        return;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/scanner',
            arguments: {'action': 'manual', 'prefill': qrData});
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Error processing image: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pickAndProcessImage());
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF008080);
    return Scaffold(
      appBar: AppBar(title: const Text('Upload QR Image')),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Processing image...', style: GoogleFonts.inter()),
                ],
              )
            : _error != null
                ? ErrorMessage(
                    title: 'Error',
                    message: _error!,
                    onRetry: _pickAndProcessImage,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 64, color: accentColor),
                      const SizedBox(height: 16),
                      Text('Select a QR code image to continue.',
                          style: GoogleFonts.inter(fontSize: 18)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _pickAndProcessImage,
                      ),
                    ],
                  ),
      ),
    );
  }
}
