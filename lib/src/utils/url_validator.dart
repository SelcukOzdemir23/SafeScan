class UrlValidator {
  /// Performs a basic check if the string is a plausible HTTP/HTTPS URL.
  /// This is not exhaustive but helps filter out clearly non-URL data before
  /// making an API call. The backend should perform more robust validation.
  static bool isValidHttpUrl(String? potentialUrl) {
    if (potentialUrl == null || potentialUrl.isEmpty) {
      return false;
    }
    // Check if it starts with http:// or https://
    if (!potentialUrl.startsWith('http://') && !potentialUrl.startsWith('https://')) {
       return false;
    }

    // Use Uri.tryParse for a more robust format check
    final Uri? uri = Uri.tryParse(potentialUrl);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    // Could add more checks like uri.host.isNotEmpty, but keep it simple here.
  }
}
