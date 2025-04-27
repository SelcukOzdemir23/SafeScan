
import 'package:flutter/material.dart';

/// Represents the safety status of a URL.
enum SafetyStatus {
  safe,
  unsafe,
  warning,
  unknown;

  /// Provides a user-friendly display name for the status.
  String get displayName {
    switch (this) {
      case SafetyStatus.safe:
        return 'Safe';
      case SafetyStatus.unsafe:
        return 'Unsafe';
      case SafetyStatus.warning:
        return 'Warning';
      case SafetyStatus.unknown:
      default:
        return 'Unknown';
    }
  }

  /// Provides a representative color for the status.
  Color get color {
    switch (this) {
      case SafetyStatus.safe:
        return Colors.green;
      case SafetyStatus.unsafe:
        return Colors.red;
      case SafetyStatus.warning:
        return Colors.orange;
      case SafetyStatus.unknown:
      default:
        return Colors.grey;
    }
  }

  /// Provides a suitable icon for the status.
  IconData get icon {
     switch (this) {
      case SafetyStatus.safe:
        return Icons.check_circle_outline;
      case SafetyStatus.unsafe:
        return Icons.dangerous_outlined;
      case SafetyStatus.warning:
        return Icons.warning_amber_outlined;
      case SafetyStatus.unknown:
      default:
        return Icons.help_outline;
    }
  }

  /// Parses a string (typically from an API response) into a SafetyStatus.
  static SafetyStatus fromString(String? statusString) {
    switch (statusString?.toLowerCase()) {
      case 'safe':
        return SafetyStatus.safe;
      case 'unsafe':
      case 'malicious': // Allow for variations
        return SafetyStatus.unsafe;
      case 'warning':
      case 'suspicious': // Allow for variations
        return SafetyStatus.warning;
      case 'unknown':
      default:
        return SafetyStatus.unknown;
    }
  }
}

/// Represents the result of a URL safety check.
class SafetyResult {
  final String url;
  final SafetyStatus status;
  final String message; // Message from the backend explaining the status

  SafetyResult({
    required this.url,
    required this.status,
    required this.message,
  });

  /// Creates a SafetyResult instance from a JSON map (API response).
  factory SafetyResult.fromJson(Map<String, dynamic> json) {
    return SafetyResult(
      url: json['url'] ?? '',
      status: SafetyStatus.fromString(json['status']),
      message: json['message'] ?? 'No additional information provided.', // Default message
    );
  }
}
