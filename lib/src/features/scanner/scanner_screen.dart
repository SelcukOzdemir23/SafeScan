
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safescan_flutter/src/features/result/result_screen.dart';
import 'package:safescan_flutter/src/utils/validators.dart';
import 'package:safescan_flutter/src/widgets/qr_scanner_overlay.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  bool _isProcessing = false; // To prevent multiple navigations

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraPermissionStatus = status;
    });
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_isProcessing) return; // Don't process if already processing

    final String? code = capture.barcodes.first.rawValue;

    if (code != null && isValidUrl(code)) {
       setState(() {
        _isProcessing = true; // Mark as processing
      });
      // Vibrate or give feedback (optional)
      // HapticFeedback.mediumImpact();

      // Navigate to ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(scannedUrl: code),
        ),
      ).then((_) {
         // Reset processing flag when returning from ResultScreen
         if (mounted) { // Check if widget is still in tree
           setState(() {
            _isProcessing = false;
          });
         }
      });
    } else if (code != null) {
      // Handle non-URL QR codes (optional: show a message)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
            content: Text('Scanned QR code does not contain a valid URL.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeScan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_cameraPermissionStatus) {
      case PermissionStatus.granted:
        return Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              // fit: BoxFit.contain,
              onDetect: _handleDetection,
               controller: MobileScannerController(
                // detectionSpeed: DetectionSpeed.normal, // Default
                // facing: CameraFacing.back, // Default
                // torchEnabled: false, // Default
               ),
            ),
            const QRScannerOverlay(),
          ],
        );
      case PermissionStatus.denied:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Camera permission denied.'),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                child: const Text('Request Permission'),
              ),
            ],
          ),
        );
      case PermissionStatus.permanentlyDenied:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Camera permission permanently denied.'),
              ElevatedButton(
                onPressed: openAppSettings,
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      default: // Handles restricted, limited, provisional
        return const Center(
          child: Text('Camera permission is restricted or unavailable.'),
        );
    }
  }
}
