import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safescan_flutter/src/models/safety_result.dart';

/// Modern Material 3 theme for the SafeScan app
class AppTheme {
  // Color constants
  static const _primaryColor = Color(0xFF0D6EFD); // Modern blue
  static const _secondaryColor = Color(0xFF6C757D); // Modern gray
  static const _errorColor = Color(0xFFDC3545); // Modern red
  static const _warningColor = Color(0xFFFFC107); // Modern amber
  static const _successColor = Color(0xFF198754); // Modern green

  // Public color constants for use in other parts of the app
  static const Color primaryColor = _primaryColor;
  static const Color secondaryColor = _secondaryColor;
  static const Color errorColor = _errorColor;
  static const Color warningColor = _warningColor;
  static const Color successColor = _successColor;

  // Border radius constants
  static const double _smallRadius = 8.0;
  static const double _mediumRadius = 12.0;
  static const double _largeRadius = 16.0;

  /// Light theme configuration
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      secondary: _secondaryColor,
      error: _errorColor,
      // Custom color extensions
      surface: Colors.white,
      onSurface: Colors.black87,
      // Container colors for Material 3
      primaryContainer:
          Color.alphaBlend(Colors.white.withOpacity(0.9), _primaryColor),
      onPrimaryContainer: _primaryColor.withOpacity(0.9),
      secondaryContainer:
          Color.alphaBlend(Colors.white.withOpacity(0.9), _secondaryColor),
      onSecondaryContainer: _secondaryColor.withOpacity(0.9),
      errorContainer:
          Color.alphaBlend(Colors.white.withOpacity(0.9), _errorColor),
      onErrorContainer: _errorColor.withOpacity(0.9),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,

      // Text theme with Google Fonts
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: colorScheme.surface,

      // Card theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(_largeRadius)),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      secondary: _secondaryColor,
      error: _errorColor,
      // Custom color extensions
      surface: const Color(0xFF212529),
      onSurface: Colors.white.withAlpha(222), // ~87% opacity
      // Container colors for Material 3
      primaryContainer: Color.alphaBlend(const Color(0xFF212529).withAlpha(204),
          _primaryColor), // ~80% opacity
      onPrimaryContainer: Colors.white.withAlpha(230), // ~90% opacity
      secondaryContainer: Color.alphaBlend(
          const Color(0xFF212529).withAlpha(204), _secondaryColor),
      onSecondaryContainer: Colors.white.withAlpha(230),
      errorContainer:
          Color.alphaBlend(const Color(0xFF212529).withAlpha(204), _errorColor),
      onErrorContainer: Colors.white.withAlpha(230),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,

      // Text theme with Google Fonts
      textTheme:
          GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          letterSpacing: -1.0,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white.withAlpha(222), // ~87% opacity
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white.withAlpha(222), // ~87% opacity
        ),
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: colorScheme.surface,

      // Card theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_smallRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(_largeRadius)),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_mediumRadius),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color.alphaBlend(
            Colors.black.withAlpha(51), colorScheme.surface), // ~20% opacity
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(
              color: colorScheme.outline.withAlpha(128)), // ~50% opacity
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_smallRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  /// Get color for safety status
  static Color getSafetyStatusColor(SafetyStatus status, BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case SafetyStatus.safe:
        return _successColor;
      case SafetyStatus.unsafe:
        return _errorColor;
      case SafetyStatus.warning:
        return _warningColor;
      case SafetyStatus.unknown:
        return _secondaryColor;
      case SafetyStatus.error:
        return isDark ? Colors.grey.shade600 : Colors.grey.shade700;
    }
  }

  /// Get background color for safety status (lighter version)
  static Color getSafetyStatusBackgroundColor(
      SafetyStatus status, BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = getSafetyStatusColor(status, context);

    return isDark
        ? baseColor.withAlpha(51)
        : baseColor.withAlpha(25); // 20% or 10% opacity
  }
}
