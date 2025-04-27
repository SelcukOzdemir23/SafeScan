import 'package:flutter/material.dart';

/// Enum defining the possible safety statuses
enum SafetyStatus {
  safe,
  unsafe,
  warning, // Could be suspicious, phishing attempt, etc.
  unknown, // Could not determine status
  error // Error during the check process
}

/// Extension to add properties like display name and color to the enum
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
    switch (this) {
      case SafetyStatus.safe:
        return Colors.green.shade600;
      case SafetyStatus.unsafe:
        return Colors.red.shade700;
      case SafetyStatus.warning:
        return Colors.orange.shade700;
      case SafetyStatus.unknown:
        return Colors.grey.shade600;
      case SafetyStatus.error:
        return Colors.blueGrey.shade600;
    }
  }

  IconData get icon {
    switch (this) {
      case SafetyStatus.safe:
        return Icons.check_circle_outline_rounded;
      case SafetyStatus.unsafe:
        return Icons.dangerous_outlined;
      case SafetyStatus.warning:
        return Icons.warning_amber_rounded;
      case SafetyStatus.unknown:
        return Icons.help_outline_rounded;
      case SafetyStatus.error:
        return Icons.error_outline_rounded;
    }
  }
}

/// Class representing the result of a safety check
class SafetyResult {
  final String url;
  final SafetyStatus status;
  final String threatType;
  final String description;

  // Computed property for backward compatibility
  bool get isSafe => status == SafetyStatus.safe;

  const SafetyResult({
    required this.url,
    required this.status,
    required this.threatType,
    required this.description,
  });

  // Factory constructor for creating from the old boolean-based model
  factory SafetyResult.fromLegacy({
    required String url,
    required bool isSafe,
    required String threatType,
    required String description,
  }) {
    return SafetyResult(
      url: url,
      status: isSafe ? SafetyStatus.safe : SafetyStatus.unsafe,
      threatType: threatType,
      description: description,
    );
  }

  // Factory constructor for creating an error result easily
  factory SafetyResult.error({
    required String url,
    String threatType = 'Error',
    String description = 'Failed to check URL safety',
  }) {
    return SafetyResult(
      url: url,
      status: SafetyStatus.error,
      threatType: threatType,
      description: description,
    );
  }

  // Factory constructor for parsing from JSON
  factory SafetyResult.fromJson(Map<String, dynamic> json) {
    // Handle both new and legacy formats
    if (json.containsKey('status')) {
      // New format with status enum
      SafetyStatus status;
      final statusStr = json['status']?.toString().toLowerCase();

      switch (statusStr) {
        case 'safe':
          status = SafetyStatus.safe;
          break;
        case 'unsafe':
          status = SafetyStatus.unsafe;
          break;
        case 'warning':
        case 'suspicious':
          status = SafetyStatus.warning;
          break;
        case 'unknown':
          status = SafetyStatus.unknown;
          break;
        case 'error':
          status = SafetyStatus.error;
          break;
        default:
          status = SafetyStatus.unknown;
      }

      return SafetyResult(
        url: json['url'] as String,
        status: status,
        threatType: json['threatType'] as String,
        description: json['description'] as String,
      );
    } else {
      // Legacy format with isSafe boolean
      return SafetyResult.fromLegacy(
        url: json['url'] as String,
        isSafe: json['isSafe'] as bool,
        threatType: json['threatType'] as String,
        description: json['description'] as String,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'status': status.name,
      'isSafe': isSafe, // For backward compatibility
      'threatType': threatType,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'SafetyResult(url: $url, status: ${status.name}, threatType: $threatType, description: $description)';
  }
}
