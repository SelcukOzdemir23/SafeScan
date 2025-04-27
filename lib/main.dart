import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/features/scanner/scanner_screen.dart';
import 'package:safescan_flutter/src/features/scanner/start_screen.dart';
import 'package:safescan_flutter/src/features/result/result_screen.dart';
import 'package:safescan_flutter/src/config/app_theme.dart';
import 'package:safescan_flutter/src/widgets/error_boundary.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/features/scanner/qr_image_page.dart';
import 'package:safescan_flutter/src/features/scanner/manual_url_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global error caught: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  runApp(const SafeScanApp());
}

class SafeScanApp extends StatelessWidget {
  const SafeScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp(
        title: 'SafeScan QR',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const ErrorBoundary(child: StartScreen()),
        onGenerateRoute: (settings) {
          if (settings.name == '/scanner') {
            return MaterialPageRoute(
              builder: (context) => const ErrorBoundary(
                child: ScannerScreen(),
              ),
            );
          }
          if (settings.name == '/qr_image') {
            return MaterialPageRoute(
              builder: (context) => const ErrorBoundary(child: QrImagePage()),
            );
          }
          if (settings.name == '/manual_url') {
            final args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => ErrorBoundary(
                child: ManualUrlPage(
                    prefill: args is Map ? args['prefill'] : null),
              ),
            );
          }
          if (settings.name == '/result') {
            final args = settings.arguments;
            if (args is SafetyResult) {
              return MaterialPageRoute(
                builder: (context) {
                  return ErrorBoundary(
                    child: ResultScreen(result: args),
                  );
                },
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
