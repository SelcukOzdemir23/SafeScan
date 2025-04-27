bool isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
  } catch (e) {
    return false;
  }
}

bool isSecureUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme && uri.scheme == 'https' && uri.host.isNotEmpty;
  } catch (e) {
    return false;
  }
}

String? sanitizeUrl(String url) {
  try {
    final uri = Uri.parse(url.trim());
    if (!uri.hasScheme) {
      // Try adding https by default
      return 'https://${url.trim()}';
    }
    return url.trim();
  } catch (e) {
    return null;
  }
}
