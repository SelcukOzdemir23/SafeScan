import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safescan_flutter/src/services/url_safety_service.dart';
import 'package:safescan_flutter/src/utils/constants.dart';
import 'package:safescan_flutter/src/utils/url_validator.dart';
import 'package:safescan_flutter/src/widgets/error_message.dart';
import 'package:safescan_flutter/src/widgets/permission_message.dart';
import 'package:safescan_flutter/src/widgets/qr_scanner_overlay.dart';
import 'package:safescan_flutter/src/widgets/action_selection_sheet.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  late final MobileScannerController _controller;
  final UrlSafetyService _urlSafetyService = UrlSafetyService();
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
        onUploadImage: () {
          Navigator.pushNamed(context, '/qr_image');
        },
        onEnterUrl: () {
          Navigator.pushNamed(context, '/manual_url');
        },
      ),
    );
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
                  color: _controller.torchEnabled
                      ? Colors.amber
                      : Theme.of(context).colorScheme.onPrimary,
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
            QRScannerOverlay(
              scanAreaSize: AppConstants.scannerOverlaySize,
              overlayColour: Colors.black.withAlpha(150),
              scanAreaHint: AppConstants.scannerHint,
            ),
          if (_isCheckingUrl)
            ColoredBox(
              color: Colors.black.withAlpha(200),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppConstants.checkingUrlMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showActionSelectionSheet,
        icon: const Icon(Icons.more_horiz),
        label: const Text('More Options'),
        elevation: 4,
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
