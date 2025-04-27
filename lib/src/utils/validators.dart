/// Simple URL validation function.
///
/// Checks if the provided string is a valid URL using a basic regular expression.
/// This checks for common schemes (http, https, ftp) and basic structure.
/// It's not exhaustive but covers most common web URLs found in QR codes.
///
/// Args:
///   url (String?): The string to validate.
///
/// Returns:
///   bool: True if the string appears to be a valid URL, false otherwise.
bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  // Basic check for http, https, or ftp schemes and some domain structure.
  // Allows for IP addresses and localhost.
  // This is a simplified regex; more complex ones exist but might be overkill.
   final uri = Uri.tryParse(url);
   // Check if parsing was successful and if it has a scheme (like http, https)
   // and a host (like example.com, 192.168.1.1).
   // Allow schemes like http, https, ftp. Add others if needed.
   return uri != null &&
          uri.hasScheme &&
          uri.hasAuthority &&
          (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'ftp');


  // --- Alternative Regex Approach (commented out) ---
  // final RegExp urlRegExp = RegExp(
  //   r'^(https?|ftp):\/\/' // Scheme (http, https, ftp)
  //   r'([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,}' // Domain name
  //   r'(:[0-9]+)?' // Optional port
  //   r'(\/[^\s]*)?$', // Optional path
  //   caseSensitive: false,
  // );
  // return urlRegExp.hasMatch(url);
}
