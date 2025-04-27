import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/services/qr_image_service.dart';
import 'package:safescan_flutter/src/utils/constants.dart';
import 'package:safescan_flutter/src/utils/url_validator.dart';
import 'package:safescan_flutter/src/widgets/error_message.dart';
import 'package:safescan_flutter/src/widgets/input_bottom_sheet.dart';
import 'package:safescan_flutter/src/widgets/permission_message.dart';
import 'package:safescan_flutter/src/widgets/qr_scanner_overlay.dart';
import 'package:safescan_flutter/src/widgets/action_selection_sheet.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatefulWidget {
  final String? initialAction;
  const ScannerScreen({super.key, this.initialAction});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late final MobileScannerController _controller;
  final UrlSafetyService _urlSafetyService = UrlSafetyService();
  final QrImageService _qrImageService = QrImageService();
  final ValueNotifier<bool> _hasTorch = ValueNotifier<bool>(false);

  PermissionStatus _cameraPermissionStatus = PermissionStatus.denied;
  bool _isCheckingUrl = false;
  bool _isCameraInitializing = true;
  String? _initializationError;
  Timer? _initTimeout;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
    _requestCameraPermission();
    // Trigger initial action if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialAction == 'upload') {
        _pickAndProcessImage();
      } else if (widget.initialAction == 'manual') {
        _showInputBottomSheet();
      }
    });
  }

  void _initializeController() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    // Set initial torch availability
    _controller.start().then((_) {
      if (mounted) {
        _hasTorch.value = true;
      }
    });
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _initTimeout = Timer(const Duration(seconds: 10), () {
      if (mounted && _isCameraInitializing) {
        setState(() {
          _isCameraInitializing = false;
          _initializationError =
              'Camera initialization timed out. Please try again.';
        });
      }
    });

    try {
      await _controller.start();
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
          _initializationError = 'Failed to initialize camera: $error';
        });
      }
      debugPrint('Camera initialization error: $error');
    } finally {
      _initTimeout?.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      default:
        break;
    }
  }

  Future<void> _handleAppResumed() async {
    if (_cameraPermissionStatus.isGranted && !_isCheckingUrl) {
      await _initializeCamera();
    }
  }

  Future<void> _handleAppPaused() {
    debugPrint('App paused - stopping camera');
    return _controller.stop();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _cameraPermissionStatus = status;
        if (!status.isGranted) {
          _isCameraInitializing = false;
          _initializationError = 'Camera permission denied.';
        }
      });
    }
  }

  Future<void> _processQrImage(File imageFile) async {
    setState(() => _isCheckingUrl = true);

    try {
      final String? qrData = await _qrImageService.processQrImage(imageFile);

      if (qrData == null) {
        _showErrorDialog(
          'Invalid QR Code',
          'No valid QR code found in the image.',
        );
        return;
      }

      await _checkUrl(qrData);
    } catch (e) {
      debugPrint('Error processing QR image: $e');
      _showErrorDialog(
        'Processing Error',
        'Failed to process the QR code image. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isCheckingUrl = false);
      }
    }
  }

  void _showInputBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InputBottomSheet(
        onUrlSubmitted: _checkUrl,
        onImageSelected: _processQrImage,
      ),
    );
  }

  void _showActionSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ActionSelectionSheet(
        onScanQr: () {}, // Just dismisses, camera is default
        onUploadImage: _pickAndProcessImage,
        onEnterUrl: _showInputBottomSheet,
      ),
    );
  }

  Future<void> _pickAndProcessImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await _processQrImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _checkUrl(String url) async {
    if (_isCheckingUrl) return;

    final sanitizedUrl = sanitizeUrl(url);
    if (sanitizedUrl == null || !isValidUrl(sanitizedUrl)) {
      _showErrorDialog(
        AppConstants.invalidUrlTitle,
        AppConstants.invalidUrlMessage,
      );
      return;
    }

    setState(() => _isCheckingUrl = true);

    try {
      final result = await _urlSafetyService.checkUrlSafety(sanitizedUrl);
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/result',
          arguments: result,
        ).then((_) {
          if (mounted) {
            setState(() => _isCheckingUrl = false);
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking URL safety: $e');
      _showErrorDialog(
        AppConstants.networkErrorTitle,
        AppConstants.networkErrorMessage,
      );
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
    if (mounted) {
      setState(() => _isCheckingUrl = false);
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isCheckingUrl) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? scannedData = barcodes.first.rawValue;
    if (scannedData == null || scannedData.isEmpty) return;

    await _checkUrl(scannedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeScan QR'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _hasTorch,
            builder: (context, hasTorch, child) {
              if (!hasTorch ||
                  !_cameraPermissionStatus.isGranted ||
                  _isCameraInitializing) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(
                  _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
                  color:
                      _controller.torchEnabled ? Colors.yellow : Colors.white,
                ),
                onPressed: () => _controller.toggleTorch(),
                tooltip: 'Toggle flash',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildCameraOrMessage(),
          if (_cameraPermissionStatus.isGranted &&
              !_isCameraInitializing &&
              _initializationError == null)
            const QRScannerOverlay(
              scanAreaSize: AppConstants.scannerOverlaySize,
              overlayColour: Colors.black54,
              scanAreaHint: AppConstants.scannerHint,
            ),
          if (_isCheckingUrl)
            ColoredBox(
              color: Colors.black.withAlpha(179),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      AppConstants.checkingUrlMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showActionSelectionSheet,
        icon: const Icon(Icons.qr_code),
        label: const Text('Scan or Upload'),
      ),
    );
  }

  Widget _buildCameraOrMessage() {
    if (_initializationError != null) {
      return ErrorMessage(
        title: 'Camera Error',
        message: _initializationError!,
        onRetry: _initializeCamera,
      );
    }

    if (_isCameraInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_cameraPermissionStatus) {
      case PermissionStatus.granted:
        return MobileScanner(
          key: _qrKey,
          controller: _controller,
          onDetect: _onDetect,
          errorBuilder: (context, error, child) {
            debugPrint("Scanner error: $error");
            return ErrorMessage(
              title: 'Scanner Error',
              message: error.toString(),
              onRetry: _initializeCamera,
            );
          },
        );
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return PermissionMessage(
          status: _cameraPermissionStatus,
          onRequestPermission: _requestCameraPermission,
        );
      default:
        return const Center(child: Text('Checking camera permissions...'));
    }
  }

  @override
  void dispose() {
    _hasTorch.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _initTimeout?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
