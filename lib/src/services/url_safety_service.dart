
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safescan_flutter/src/models/safety_result.dart';

class UrlSafetyService {
  // TODO: Replace with your actual backend endpoint URL
  // This could be a Firebase Cloud Function URL, a Next.js API route, etc.
  // For local testing with a simulator/emulator, use the appropriate local IP:
  // Android Emulator: 'http://10.0.2.2:PORT'
  // iOS Simulator: 'http://localhost:PORT' or 'http://127.0.0.1:PORT'
  // Replace PORT with the port your backend is running on (e.g., 3000 for Next.js default)
  // Example for Next.js default running locally:
   final String _baseUrl = 'http://10.0.2.2:3000/api/check-url'; // Android
  // final String _baseUrl = 'http://localhost:3000/api/check-url'; // iOS / Web

  /// Checks the safety of a given URL by calling the backend API.
  Future<SafetyResult> checkUrlSafety(String url) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Assume the backend returns a JSON with 'status' and optionally 'message'
        return SafetyResult.fromJson({
          'url': url, // Include the original URL in the result
          'status': data['status'],
          'message': data['message'] ?? _getDefaultMessage(SafetyStatus.fromString(data['status'])),
        });
      } else {
        // Handle backend errors (e.g., 4xx, 5xx)
        print('Backend error: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        // Return an 'unknown' status with an error message
         return SafetyResult(
            url: url,
            status: SafetyStatus.unknown,
            message: 'Failed to get safety status from server (Code: ${response.statusCode}).');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error calling safety check API: $e');
       return SafetyResult(
          url: url,
          status: SafetyStatus.unknown,
          message: 'Could not connect to the safety check service. Please check your internet connection.');
    }
  }

  // Helper to provide default messages based on status if backend doesn't provide one
  String _getDefaultMessage(SafetyStatus status) {
     switch (status) {
      case SafetyStatus.safe:
        return 'This URL appears to be safe based on our checks.';
      case SafetyStatus.unsafe:
        return 'This URL is potentially unsafe or malicious. Avoid visiting.';
      case SafetyStatus.warning:
        return 'Exercise caution with this URL. It might be suspicious or contain unwanted content.';
      case SafetyStatus.unknown:
      default:
        return 'The safety status of this URL could not be determined.';
    }
  }
}
