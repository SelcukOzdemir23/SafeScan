import 'package:flutter/material.dart';

class AppTheme {
  // Define Colors based on guidelines
  static const Color primaryColor = Color(0xFFFFFFFF); // White
  static const Color secondaryColor = Color(0xFFF0F0F0); // Light Gray
  static const Color accentColor = Color(0xFF008080); // Teal
  static const Color textColor = Color(0xFF090909); // Dark Gray/Black for text
  static const Color safeColor = Colors.green; // Green for Safe status
  static const Color unsafeColor = Colors.red; // Red for Unsafe status
  static const Color warningColor = Colors.orange; // Orange for Warning status
  static const Color unknownColor = Colors.grey; // Grey for Unknown status

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor, // Light gray background
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor, // White AppBar
      foregroundColor: textColor, // Dark text/icons on AppBar
      elevation: 1.0, // Subtle shadow
      iconTheme: IconThemeData(color: accentColor), // Teal icons
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w600, // Slightly bolder title
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: accentColor, // Teal as the primary action color
      secondary: accentColor, // Teal for secondary elements like FAB
      surface: primaryColor, // White for card backgrounds etc.
      background: secondaryColor, // Light gray main background
      error: unsafeColor, // Red for errors
      onPrimary: primaryColor, // Text on Teal buttons (White)
      onSecondary: primaryColor, // Text on Teal elements (White)
      onSurface: textColor, // Text on White surfaces (Dark)
      onBackground: textColor, // Text on Light Gray background (Dark)
      onError: primaryColor, // Text on Red error backgrounds (White)
    ),
    cardTheme: CardTheme(
      color: primaryColor, // White cards
      elevation: 2.0, // Soft shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    ),
    textTheme: const TextTheme(
      // Define text styles if needed, otherwise defaults are fine
      bodyLarge: TextStyle(color: textColor, fontSize: 16.0),
      bodyMedium: TextStyle(color: textColor, fontSize: 14.0),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(
          color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w500), // For buttons
    ).apply(
      fontFamily: 'Arial', // Specify a clear, readable font if needed
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: accentColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor, // Teal background
        foregroundColor: primaryColor, // White text
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
         foregroundColor: accentColor, // Teal text/border
         side: const BorderSide(color: accentColor, width: 1.5),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8.0),
         ),
         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
         textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
       ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentColor, // Teal loading indicators
    ),
     dialogTheme: DialogTheme(
       backgroundColor: primaryColor,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12.0),
       ),
     ),
     snackBarTheme: SnackBarThemeData(
       backgroundColor: Colors.grey[800], // Dark background for snackbars
       contentTextStyle: const TextStyle(color: Colors.white),
     ),
  );

  // Optional: Define a dark theme if needed
  // static final ThemeData darkTheme = ThemeData(...);
}
