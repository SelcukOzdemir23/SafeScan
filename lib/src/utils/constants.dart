// lib/src/utils/constants.dart

class AppConstants {
  // Scanner
  static const double scannerOverlaySize = 250.0;
  static const int scannerTimeout = 30; // seconds
  static const Duration resultAnimationDuration = Duration(milliseconds: 400);

  // URL Safety
  static const Duration urlCheckTimeout = Duration(seconds: 5);
  static const List<String> suspiciousKeywords = [
    'login',
    'signin',
    'account',
    'banking',
    'verify',
    'secure',
    'security',
    'password',
    'credential',
    'payment',
    'paypal',
    'credit',
    'debit',
    'card',
  ];

  // Messages - Status
  static const String safeMessage =
      'No immediate threats detected. Always exercise caution when visiting new websites.';
  static const String insecureConnectionTitle = 'Insecure Connection';
  static const String insecureConnectionMessage =
      'This website does not use HTTPS encryption. Your connection may not be secure.';
  static const String suspiciousDomainTitle = 'Suspicious Domain';
  static const String suspiciousDomainMessage =
      'This domain contains keywords often associated with phishing attempts. Be extra cautious.';

  // Messages - Errors
  static const String networkErrorTitle = 'Network Error';
  static const String networkErrorMessage =
      'Could not connect to the safety check service. Please check your internet connection.';
  static const String invalidUrlTitle = 'Invalid URL';
  static const String invalidUrlMessage =
      'The URL is not accessible or returned an error';
  static const String invalidUrlFormatTitle = 'Invalid URL Format';
  static const String invalidUrlFormatMessage =
      'The provided URL is not properly formatted';
  static const String invalidSchemaTitle = 'Invalid URL Schema';
  static const String invalidSchemaMessage =
      'URL must start with http:// or https://';
  static const String timeoutTitle = 'Request Timeout';
  static const String timeoutMessage =
      'The request took too long to complete. Please try again.';
  static const String connectionErrorTitle = 'Connection Failed';
  static const String connectionErrorMessage =
      'Could not establish a connection to the URL';
  static const String errorTitle = 'Error';
  static const String errorMessage =
      'An unexpected error occurred while checking the URL';
  static const String rateLimitTitle = 'Too Many Requests';
  static const String rateLimitMessage =
      'You have made too many requests. Please wait a moment and try again.';

  // Messages - Permissions
  static const String cameraPermissionTitle = 'Camera Access Required';
  static const String cameraPermissionMessage =
      'SafeScan needs camera access to scan QR codes and check their safety.';
  static const String scannerHint = 'Position QR code in frame';
  static const String checkingUrlMessage = 'Checking URL safety...';

  // UI Constants
  static const double cardBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 48.0;
  static const double standardPadding = 16.0;
  static const double smallPadding = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}
