import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safescan_flutter/src/services/qr_image_service.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/widgets/error_message.dart';

class QrImagePage extends StatefulWidget {
  const QrImagePage({super.key});

  @override
  State<QrImagePage> createState() => _QrImagePageState();
}

class _QrImagePageState extends State<QrImagePage> {
  bool _isProcessing = false;
  String? _error;
  String? _detectedUrl;
  final QrImageService _qrImageService = QrImageService();
  final UrlSafetyService _urlSafetyService = UrlSafetyService();

  Future<void> _pickAndProcessImage() async {
    setState(() {
      _isProcessing = true;
      _error = null;
      _detectedUrl = null;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      final imageFile = File(image.path);

      // First step: Extract URL from QR code
      setState(() => _isProcessing = true);
      final String? qrData = await _qrImageService.processQrImage(imageFile);

      if (qrData == null) {
        setState(() {
          _isProcessing = false;
          _error = 'No valid QR code found in the image.';
        });
        return;
      }

      // Store the detected URL
      setState(() {
        _detectedUrl = qrData;
        _isProcessing = true; // Still processing for safety check
      });

      // Second step: Check URL safety
      try {
        final safetyResult = await _urlSafetyService.checkUrlSafety(qrData);

        if (mounted) {
          // Navigate to result screen with safety information
          Navigator.pushNamed(
            context,
            '/result',
            arguments: safetyResult,
          );
        }
      } catch (e) {
        setState(() {
          _isProcessing = false;
          _error = 'Error checking URL safety: $e';
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _error = 'Error processing image: $e';
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    setState(() {
      _isProcessing = true;
      _error = null;
      _detectedUrl = null;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      final imageFile = File(image.path);

      // First step: Extract URL from QR code
      setState(() => _isProcessing = true);
      final String? qrData = await _qrImageService.processQrImage(imageFile);

      if (qrData == null) {
        setState(() {
          _isProcessing = false;
          _error = 'No valid QR code found in the image.';
        });
        return;
      }

      // Store the detected URL
      setState(() {
        _detectedUrl = qrData;
        _isProcessing = true; // Still processing for safety check
      });

      // Second step: Check URL safety
      try {
        final safetyResult = await _urlSafetyService.checkUrlSafety(qrData);

        if (mounted) {
          // Navigate to result screen with safety information
          Navigator.pushNamed(
            context,
            '/result',
            arguments: safetyResult,
          );
        }
      } catch (e) {
        setState(() {
          _isProcessing = false;
          _error = 'Error checking URL safety: $e';
        });
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
    // Automatically open the image picker when the page loads
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showImageSourceDialog());
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndProcessImage();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload QR Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('QR Image Upload Help'),
                  content: const Text(
                    'Upload an image containing a QR code to scan it. '
                    'Make sure the QR code is clearly visible and not blurry. '
                    'You can select an image from your gallery or take a new photo.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : _error != null
              ? ErrorMessage(
                  title: 'Error',
                  message: _error!,
                  onRetry: _showImageSourceDialog,
                )
              : _buildUploadView(),
      bottomNavigationBar: _isProcessing || _error != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        onPressed: _pickAndProcessImage,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        onPressed: _pickImageFromCamera,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              _detectedUrl != null
                  ? 'Checking URL Safety...'
                  : 'Processing QR code...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_detectedUrl != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _detectedUrl!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Text(
                'Please wait while we analyze the image',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(150),
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildUploadView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                MdiIcons.qrcodeScan,
                size: 64,
                color: colorScheme.primary,
              ),
            ).animate().scale(
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: 32),
            Text(
              'Upload QR Code Image',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
            const SizedBox(height: 16),
            Text(
              'Select an image from your gallery or take a photo of a QR code to scan it',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
            const SizedBox(height: 48),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(80),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    MdiIcons.imageMultiple,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to select a QR code image',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Supported formats: JPG, PNG, HEIC',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  delay: 600.ms,
                  duration: 500.ms,
                  curve: Curves.easeOutQuad,
                ),
          ],
        ),
      ),
    );
  }
}
