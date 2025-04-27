
import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/config/theme.dart';
import 'package:safescan_flutter/src/features/scanner/scanner_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized for plugins
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeScanApp());
}

class SafeScanApp extends StatelessWidget {
  const SafeScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeScan',
      theme: AppTheme.lightTheme, // Apply the defined light theme
      // darkTheme: AppTheme.darkTheme, // Optional: Define and apply a dark theme
      // themeMode: ThemeMode.system, // Optional: Use system theme setting
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: const ScannerScreen(), // Start with the scanner screen
    );
  }
}
