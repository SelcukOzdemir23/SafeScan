
/// Validates if the given string is a valid URL format.
///
/// This is a basic check and might not cover all edge cases,
/// but it's generally sufficient for typical HTTP/HTTPS URLs.
bool isValidUrl(String? urlString) {
  if (urlString == null || urlString.isEmpty) {
    return false;
  }
  // Simple check for common URL schemes and structure
  final uri = Uri.tryParse(urlString);
  return uri != null &&
         uri.hasScheme &&
         uri.hasAuthority &&
         (uri.scheme == 'http' || uri.scheme == 'https');
}
