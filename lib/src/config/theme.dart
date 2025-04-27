
import 'package:flutter/material.dart';

class AppTheme {
  // Define colors based on style guidelines
  static const Color _primaryColor = Colors.white; // #FFFFFF
  static const Color _secondaryColor = Color(0xFFF0F0F0); // #F0F0F0 Light Gray
  static const Color _accentColor = Color(0xFF008080); // #008080 Teal
  static const Color _textColor = Colors.black87; // Readable text color on light background
  static const Color _errorColor = Colors.redAccent;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Enable Material 3 features
      brightness: Brightness.light,
      primaryColor: _primaryColor, // Not directly used by many M3 components
      scaffoldBackgroundColor: _secondaryColor, // Use light gray for background

      colorScheme: const ColorScheme.light(
        primary: _accentColor, // Use Teal as the primary action color
        onPrimary: _primaryColor, // Text/icons on primary color (white for Teal)
        secondary: _accentColor, // Can use accent again or another color
        onSecondary: _primaryColor,
        surface: _primaryColor, // Card backgrounds, dialogs (white)
        onSurface: _textColor, // Text on surface
        background: _secondaryColor, // Main background
        onBackground: _textColor, // Text on background
        error: _errorColor,
        onError: _primaryColor,
        brightness: Brightness.light, // Explicitly light
        // InversePrimary is often used for AppBar backgrounds
        inversePrimary: _accentColor,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _accentColor, // Teal app bar
        foregroundColor: _primaryColor, // White title/icons
        elevation: 1.0, // Subtle shadow
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: _primaryColor,
          // Consider adding a specific font family if needed
        ),
        iconTheme: IconThemeData(
          color: _primaryColor, // White icons in AppBar
        ),
      ),

      // Define text theme for readability
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.w400, color: _textColor),
        displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w400, color: _textColor),
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400, color: _textColor),
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400, color: _textColor),
        headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w400, color: _textColor),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400, color: _textColor),
        titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: _textColor), // App Bar title uses this if not overridden
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: _textColor),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: _textColor),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: _textColor),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: _textColor),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: _textColor),
        labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: _textColor), // Button text
        labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: _textColor),
        labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: _textColor),
      ),

      // Define button themes
       elevatedButtonTheme: ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           backgroundColor: _accentColor, // Teal buttons
           foregroundColor: _primaryColor, // White text on buttons
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8.0), // Slightly rounded corners
           ),
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           textStyle: const TextStyle(
             fontSize: 14.0,
             fontWeight: FontWeight.w500,
             letterSpacing: 1.25, // Typical for button text
           ),
         ),
       ),

      // Define card theme for consistency
      cardTheme: CardTheme(
        color: _primaryColor, // White cards
        elevation: 1.0, // Subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for cards
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),

      // Define input decoration theme for text fields (if used)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // No border by default
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: _accentColor, width: 2.0), // Teal border when focused
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),

       // Define icon theme
      iconTheme: const IconThemeData(
        color: _textColor, // Default icon color
        size: 24.0,
      ),

      // Define floating action button theme (if used)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
         backgroundColor: _accentColor,
         foregroundColor: _primaryColor,
       ),

       // Add other component themes as needed (e.g., SnackBarTheme, DialogTheme)
       snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800], // Darker background for contrast
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: _accentColor, // Teal action text color
       ),
    );
  }

  // Optional: Define a dark theme
  // static ThemeData get darkTheme {
  //   // ... Define dark theme colors and properties ...
  //   return ThemeData(...);
  // }
}
