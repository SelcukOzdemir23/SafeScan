import 'package:flutter/material.dart';
import 'package:safescan_flutter/src/config/theme.dart';
import 'package:safescan_flutter/src/features/scanner/scanner_screen.dart';
import 'package:safescan_flutter/src/features/result/result_screen.dart';
import 'package:safescan_flutter/src/models/safety_result.dart'; // Import SafetyResult

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeScan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme, // Optional: Define a dark theme
      themeMode: ThemeMode.system, // Use system theme setting
      initialRoute: '/', // Start at the scanner screen
      routes: {
        '/': (context) => const ScannerScreen(),
        // Define the result screen route if you want to navigate to it by name
        // You'll likely navigate using Navigator.push with arguments instead
        // '/result': (context) => const ResultScreen(result: /* Provide a default or dummy result */),
      },
      // Example of how to handle route generation if passing complex data
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          final args = settings.arguments as SafetyCheckResult?;
          // Ensure args are provided and valid before creating the screen
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) {
                return ResultScreen(result: args);
              },
            );
          }
          // Handle the case where args are missing or invalid
          // Maybe return to scanner or show an error
          return MaterialPageRoute(builder: (context) => const ScannerScreen()); // Fallback
        }
        // Handle other routes or unknown routes
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}
