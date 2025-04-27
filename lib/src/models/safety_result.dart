import 'package:flutter/material.dart'; // For Color

// Enum defining the possible safety statuses
enum SafetyStatus {
  safe,
  unsafe,
  warning, // Could be suspicious, phishing attempt, etc.
  unknown, // Could not determine status
  error // Error during the check process
}

// Extension to add properties like display name and color to the enum
extension SafetyStatusProperties on SafetyStatus {
  String get displayName {
    switch (this) {
      case SafetyStatus.safe:
        return 'Safe';
      case SafetyStatus.unsafe:
        return 'Unsafe';
      case SafetyStatus.warning:
        return 'Warning';
      case SafetyStatus.unknown:
        return 'Unknown';
      case SafetyStatus.error:
        return 'Check Failed';
    }
  }

  Color get color {
    // Define colors based on your theme or preference
    // These are example colors, adjust as needed
    switch (this) {
      case SafetyStatus.safe:
        return Colors.green.shade600; // Darker green for better contrast
      case SafetyStatus.unsafe:
        return Colors.red.shade700; // Darker red
      case SafetyStatus.warning:
        return Colors.orange.shade700; // Darker orange
      case SafetyStatus.unknown:
        return Colors.grey.shade600; // Darker grey
      case SafetyStatus.error:
        return Colors.blueGrey.shade600; // A different color for errors
    }
  }

  IconData get icon {
     switch (this) {
      case SafetyStatus.safe:
        return Icons.check_circle_outline_rounded; // Checkmark icon
      case SafetyStatus.unsafe:
        return Icons.dangerous_outlined; // Danger icon
      case SafetyStatus.warning:
        return Icons.warning_amber_rounded; // Warning icon
      case SafetyStatus.unknown:
        return Icons.help_outline_rounded; // Question mark icon
      case SafetyStatus.error:
        return Icons.error_outline_rounded; // Error icon
    }
  }
}

// Class representing the result of a safety check
class SafetyCheckResult {
  final String url;
  final SafetyStatus status;
  final String? message; // Optional message (e.g., reason for warning/error)

  SafetyCheckResult({
    required this.url,
    required this.status,
    this.message,
  });

  // Factory constructor for creating an error result easily
  factory SafetyCheckResult.error({required String url, String? message}) {
    return SafetyCheckResult(
      url: url,
      status: SafetyStatus.error,
      message: message ?? 'Failed to check URL safety.',
    );
  }

  // Factory constructor for parsing from JSON (adjust keys based on your backend)
  factory SafetyCheckResult.fromJson(Map<String, dynamic> json) {
    SafetyStatus status;
    // Convert string status from backend to enum
    switch (json['status']?.toLowerCase()) {
      case 'safe':
        status = SafetyStatus.safe;
        break;
      case 'unsafe':
        status = SafetyStatus.unsafe;
        break;
      case 'warning':
      case 'suspicious': // Handle potential variations
        status = SafetyStatus.warning;
        break;
      case 'unknown':
         status = SafetyStatus.unknown;
         break;
      default:
        // If status is missing or unrecognized, treat as unknown or error
        print("Warning: Received unknown status '${json['status']}' from backend.");
        status = SafetyStatus.unknown; // Default to unknown if unrecognized
    }

    return SafetyCheckResult(
      url: json['url'] ?? '', // Provide default value if null
      status: status,
      message: json['message'], // Optional message from backend
    );
  }

  // Optional: Convert to JSON if needed (e.g., for caching)
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'status': status.name, // Convert enum to string
      'message': message,
    };
  }
}
