import 'dart:convert'; // For jsonDecode/jsonEncode
import 'package:http/http.dart' as http; // HTTP package
import 'package:safescan_flutter/src/models/safety_result.dart'; // Import your model

class UrlSafetyService {
  // IMPORTANT: Replace with your ACTUAL backend endpoint URL
  // For local development:
  // - Android Emulator: Use 10.0.2.2
  // - iOS Simulator/Physical Device (same network): Use your computer's local IP address
  // - Deployed Backend: Use the public URL
  final String _baseUrl = 'http://10.0.2.2:3000/api/check-url'; // EXAMPLE for Android Emulator on default port

  Future<SafetyCheckResult> checkUrlSafety(String url) async {
    if (url.isEmpty) {
       return SafetyCheckResult.error(url: url, message: 'URL cannot be empty.');
    }

    final Uri uri = Uri.parse(_baseUrl);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      ).timeout(const Duration(seconds: 15)); // Add a timeout

      if (response.statusCode == 200) {
        // Successfully received response from backend
        final Map<String, dynamic> data = jsonDecode(response.body);
         // Use the factory constructor to parse the JSON
         // Assuming backend returns { "url": "...", "status": "safe|unsafe|etc", "message": "..." }
        return SafetyCheckResult.fromJson(data);
      } else {
        // Handle backend errors (e.g., 400 Bad Request, 500 Internal Server Error)
        String errorMessage = 'Backend error: ${response.statusCode}';
         try {
           // Try to parse error message from backend response body
           final Map<String, dynamic> errorData = jsonDecode(response.body);
           errorMessage = errorData['error'] ?? errorData['message'] ?? errorMessage;
         } catch (_) {
           // Ignore if response body is not valid JSON
           errorMessage += '\nResponse: ${response.body}'; // Include raw response if parsing fails
         }
         print("Backend Error (${response.statusCode}): $errorMessage"); // Log error
        return SafetyCheckResult.error(url: url, message: 'Failed to get safety status from server ($errorMessage)');
      }
    } on http.ClientException catch (e) {
       // Handle network-related errors (e.g., no connection, DNS error)
       print("Network Error: $e"); // Log error
       return SafetyCheckResult.error(url: url, message: 'Network error: Could not connect to the safety service. Please check your internet connection.');
    } on TimeoutException catch (_) {
       print("Timeout Error checking URL: $url"); // Log error
       return SafetyCheckResult.error(url: url, message: 'The request timed out. The safety service might be busy or unavailable.');
    } catch (e) {
      // Handle any other unexpected errors (e.g., JSON parsing error if backend sends malformed JSON)
      print("Unexpected Error: $e"); // Log error
      return SafetyCheckResult.error(url: url, message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}
