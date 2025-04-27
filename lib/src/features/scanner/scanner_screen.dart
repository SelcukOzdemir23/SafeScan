import 'dart:convert';
import 'dart:io'; // Import Platform

import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/utils/validators.dart';
import 'package:safescan_flutter/src/widgets/qr_scanner_overlay.dart';
import 'package:http/http.dart' as http; // Import http for exceptions

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  final MobileScannerController _controller = MobileScannerController(
    // Higher resolution for better accuracy
    detectionSpeed: DetectionSpeed.normal, // Slower is more battery efficient
    facing: CameraFacing.back,
    // torchEnabled: false, // Initial torch state
  );
  final UrlSafetyService _urlSafetyService = UrlSafetyService();

  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  bool _isCheckingUrl = false;
  bool _isCameraInitializing = true; // Track camera init state
  String? _initializationError; // Store initialization error message

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    // Listen for controller ready state
     _controller.start().then((_) {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
      }
    }).catchError((error) {
       if (mounted) {
         setState(() {
           _isCameraInitializing = false;
           _initializationError = 'Failed to initialize camera: $error';
         });
       }
       print("Camera initialization error: $error"); // Log error
     });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _cameraPermissionStatus = status;
        if (status.isGranted) {
          // Start camera only if permission granted and not already started
          // Controller starting is handled in initState now
        } else {
           _isCameraInitializing = false; // Stop init indication if no permission
          _initializationError = 'Camera permission denied.';
        }
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
     // Reset checking state after showing error
     if (mounted) {
       setState(() {
         _isCheckingUrl = false;
       });
     }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isCheckingUrl) return; // Prevent multiple checks for the same scan

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? scannedData = barcodes.first.rawValue;

      if (scannedData != null && scannedData.isNotEmpty) {
        // Stop the camera to prevent further scans while processing
        // await _controller.stop(); // Stop scanning temporarily

        if (isValidUrl(scannedData)) {
          setState(() {
            _isCheckingUrl = true; // Indicate processing starts
          });

          try {
            final result = await _urlSafetyService.checkUrlSafety(scannedData);
             if (mounted) {
               // Navigate to result screen
               Navigator.pushNamed(
                 context,
                 '/result',
                 arguments: result,
               ).then((_) {
                 // When returning from result screen, reset state and restart camera
                 if (mounted) {
                   setState(() {
                     _isCheckingUrl = false;
                   });
                   // Restart scanning if permission is still granted
                  //  if (_cameraPermissionStatus.isGranted) {
                  //     _controller.start();
                  //  }
                 }
               });
             }
          } on SocketException catch (e) {
             print('Network Error: $e'); // Log error
             _showErrorDialog('Network Error',
                 'Could not connect to the safety check service. Please check your internet connection.');
          } on http.ClientException catch (e) {
            print('HTTP Client Error: $e'); // Log error
             _showErrorDialog('Service Error',
                 'Could not reach the safety check service. It might be temporarily down.');
          } catch (e) {
            // Handle other potential errors (e.g., JSON parsing, unexpected backend response)
            print('Error checking URL: $e'); // Log error
             _showErrorDialog('Error', 'An unexpected error occurred: ${e.toString()}');
          }
        } else {
          // Handle non-URL QR codes (optional)
          print('Scanned non-URL data: $scannedData');
          _showErrorDialog('Invalid QR Code', 'The scanned QR code does not contain a valid URL.');
           // Reset state and restart camera if needed
           if (mounted) {
             setState(() {
               _isCheckingUrl = false;
             });
            //  if (_cameraPermissionStatus.isGranted) {
            //    _controller.start();
            //  }
           }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeScan QR'),
        actions: [
          // Torch toggle button
          ValueListenableBuilder<TorchState>(
             valueListenable: _controller.torchState,
             builder: (context, state, child) {
              // Don't show toggle if camera isn't ready or no permission
               if (!_cameraPermissionStatus.isGranted || _isCameraInitializing) {
                 return const SizedBox.shrink();
               }
               switch (state) {
                 case TorchState.off:
                   return IconButton(
                     color: Colors.white, // Use theme color later
                     icon: const Icon(Icons.flash_off),
                     tooltip: 'Turn on flash',
                     onPressed: () async => await _controller.toggleTorch(),
                   );
                 case TorchState.on:
                   return IconButton(
                     color: Colors.yellow, // Indicate torch is on
                     icon: const Icon(Icons.flash_on),
                      tooltip: 'Turn off flash',
                     onPressed: () async => await _controller.toggleTorch(),
                   );
                 default: // Unavailable
                   return const Icon(Icons.no_flash, color: Colors.grey);
               }
             },
           ),
          // Camera switch button (optional)
          // IconButton(
          //   icon: const Icon(Icons.switch_camera),
          //   onPressed: () async => await _controller.switchCamera(),
          // ),
        ],
      ),
      body: Stack(
        children: [
          // Camera View or Permission/Error Messages
          _buildCameraOrMessage(),

          // QR Scanner Overlay
          if (_cameraPermissionStatus.isGranted && !_isCameraInitializing && _initializationError == null)
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.6)),

          // Loading Indicator
          if (_isCheckingUrl)
             Container(
              color: Colors.black.withOpacity(0.7), // Darken background
              child: const Center(
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     CircularProgressIndicator(),
                     SizedBox(height: 16),
                     Text('Checking URL safety...', style: TextStyle(color: Colors.white)),
                   ],
                 ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraOrMessage() {
    // Handle web platform (mobile_scanner limitations)
    if (kIsWeb) {
      return const Center(
        child: Text('QR scanning is not supported on the web platform.'),
      );
    }

    // Handle initialization error
     if (_initializationError != null) {
       return Center(
         child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Text(
             'Error: $_initializationError\nPlease ensure camera permissions are granted and the camera is functional.',
             textAlign: TextAlign.center,
             style: TextStyle(color: Theme.of(context).colorScheme.error),
           ),
         ),
       );
     }


    // Show loading indicator while initializing camera
    if (_isCameraInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle camera permission status
    switch (_cameraPermissionStatus) {
      case PermissionStatus.granted:
        // Ensure controller is ready before building MobileScanner
        return MobileScanner(
              key: _qrKey,
              controller: _controller,
              onDetect: _onDetect,
              // Error builder for the scanner itself
               errorBuilder: (context, error, child) {
                 print("MobileScanner Error: $error"); // Log specific scanner error
                 return Center(
                   child: Text(
                     'Scanner error: ${error.toString()}',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                   ),
                 );
               },
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
                onPressed: openAppSettings, // Requires permission_handler
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      case PermissionStatus.restricted: // iOS specific
        return const Center(
          child: Text('Camera access is restricted (e.g., by parental controls).'),
        );
      case PermissionStatus.limited: // iOS specific
         return const Center(
           child: Text('Camera access is limited. Grant full access for scanning.'),
         );
      default: // Should not happen if initState logic is correct
        return const Center(child: Text('Checking camera permissions...'));
    }
  }


  @override
  void dispose() {
    // Dispose the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}
