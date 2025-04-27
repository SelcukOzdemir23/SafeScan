import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safescan_flutter/src/utils/url_validator.dart';

class QrImageService {
  Future<String?> processQrImage(File imageFile) async {
    try {
      // Process image in an isolate for better performance
      final String? result =
          await compute(_processImageInBackground, imageFile.path);

      if (result != null) {
        // Validate if the QR content is a valid URL
        final sanitizedUrl = sanitizeUrl(result);
        if (sanitizedUrl != null && isValidUrl(sanitizedUrl)) {
          return sanitizedUrl;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error processing QR image: $e');
      return null;
    }
  }

  // This function runs in a separate isolate
  static Future<String?> _processImageInBackground(String imagePath) async {
    try {
      // Create a mobile scanner controller for image processing
      final controller = MobileScannerController();

      try {
        // Analyze the image using the controller
        final capture = await controller.analyzeImage(imagePath);

        // Check if we have any barcodes
        if (capture != null) {
          final barcodes = capture.barcodes;

          // Find the first valid barcode with a non-empty raw value
          for (final barcode in barcodes) {
            if (barcode.rawValue?.isNotEmpty == true) {
              return barcode.rawValue;
            }
          }
        }

        return null;
      } finally {
        // Always dispose the controller
        await controller.dispose();
      }
    } catch (e) {
      debugPrint('Error in background processing: $e');
      return null;
    }
  }
}
