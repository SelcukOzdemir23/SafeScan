import 'package:flutter/material.dart';

class AppTheme {
  // --- Light Theme ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal, // Or another MaterialColor swatch
      colorScheme: ColorScheme.light(
        primary: Colors.teal.shade600, // Primary color (app bars, buttons)
        onPrimary: Colors.white, // Text/icons on primary color
        secondary: Colors.amber.shade700, // Secondary accent color
        onSecondary: Colors.black, // Text/icons on secondary color
        background: Colors.grey.shade100, // App background
        onBackground: Colors.black87, // Text/icons on background
        surface: Colors.white, // Card backgrounds, dialogs
        onSurface: Colors.black87, // Text/icons on surface
        error: Colors.red.shade700, // Error color
        onError: Colors.white, // Text/icons on error color
        // Specific colors for result indicators
        primaryContainer: Colors.teal.shade100, // Lighter primary for containers
        onPrimaryContainer: Colors.teal.shade900,
        secondaryContainer: Colors.amber.shade100, // Lighter secondary for containers
        onSecondaryContainer: Colors.amber.shade900,
        errorContainer: Colors.red.shade100,
        onErrorContainer: Colors.red.shade900,

      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white, // Title and icon color
        elevation: 4.0,
      ),
      scaffoldBackgroundColor: Colors.grey.shade100,
      textTheme: _buildTextTheme(ThemeData.light().textTheme), // Use base light theme text
       buttonTheme: ButtonThemeData(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
         buttonColor: Colors.teal.shade600,
         textTheme: ButtonTextTheme.primary,
       ),
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           foregroundColor: Colors.white, backgroundColor: Colors.teal.shade600, // Text color on button
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
         ),
       ),
       outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal.shade600, // Text and border color
            side: BorderSide(color: Colors.teal.shade600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
       ),
       dialogTheme: DialogTheme(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       ),
       cardTheme: CardTheme(
         elevation: 2.0,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       ),
    );
  }

  // --- Dark Theme ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal, // Keep consistent swatch if possible
      colorScheme: ColorScheme.dark(
        primary: Colors.teal.shade400, // Slightly lighter primary for dark mode
        onPrimary: Colors.black,
        secondary: Colors.amber.shade400, // Slightly lighter secondary
        onSecondary: Colors.black,
        background: Colors.grey.shade900, // Dark background
        onBackground: Colors.white70,
        surface: Colors.grey.shade800, // Dark surface
        onSurface: Colors.white70,
        error: Colors.red.shade400, // Lighter error
        onError: Colors.black,
        // Specific colors for result indicators
         primaryContainer: Colors.teal.shade800,
         onPrimaryContainer: Colors.teal.shade100,
         secondaryContainer: Colors.amber.shade800,
         onSecondaryContainer: Colors.amber.shade100,
         errorContainer: Colors.red.shade800,
         onErrorContainer: Colors.red.shade100,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      scaffoldBackgroundColor: Colors.grey.shade900,
      textTheme: _buildTextTheme(ThemeData.dark().textTheme), // Use base dark theme text
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: Colors.teal.shade400,
        textTheme: ButtonTextTheme.primary, // Ensure text is contrasty
      ),
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           foregroundColor: Colors.black, backgroundColor: Colors.teal.shade400,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
         ),
       ),
       outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal.shade400, // Text and border color
            side: BorderSide(color: Colors.teal.shade400),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
       ),
       dialogTheme: DialogTheme(
         backgroundColor: Colors.grey.shade800,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       ),
        cardTheme: CardTheme(
         elevation: 2.0,
         color: Colors.grey.shade800,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       ),
    );
  }

   // --- Text Theme (Customize if needed) ---
   static TextTheme _buildTextTheme(TextTheme base) {
     // You can customize fonts or specific text styles here
     return base.copyWith(
       // Example: Make headlines slightly bolder
       headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
       headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
       // Add Google Fonts here if desired
     );
   }
}
