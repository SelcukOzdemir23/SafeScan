import 'dart:async';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:safescan_flutter/src/models/safety_result.dart';
import 'package:safescan_flutter/src/utils/constants.dart';

class UrlSafetyService {
  // Cache for storing recent results
  final _cache = LinkedHashMap<String, _CacheEntry>();
  final _requestTimestamps = <DateTime>[];
  static const _maxRequestsPerMinute = 30;
  static const _cacheValidityDuration = Duration(minutes: 30);

  // Rate limiting check
  bool _isRateLimited() {
    final now = DateTime.now();
    _requestTimestamps.removeWhere(
      (timestamp) => now.difference(timestamp) > const Duration(minutes: 1),
    );
    return _requestTimestamps.length >= _maxRequestsPerMinute;
  }

  // Cache cleanup
  void _cleanCache() {
    final now = DateTime.now();
    _cache.removeWhere(
        (_, entry) => now.difference(entry.timestamp) > _cacheValidityDuration);
  }

  Future<SafetyResult> checkUrlSafety(String url) async {
    try {
      // Basic URL validation and sanitization
      final Uri uri = Uri.parse(url);
      if (!uri.hasScheme || !['http', 'https'].contains(uri.scheme)) {
        return SafetyResult(
          url: url,
          status: SafetyStatus.unsafe,
          threatType: AppConstants.invalidSchemaTitle,
          description: AppConstants.invalidSchemaMessage,
        );
      }

      // Check cache first
      final cacheKey = uri.toString();
      final cachedResult = _cache[cacheKey];
      if (cachedResult != null &&
          DateTime.now().difference(cachedResult.timestamp) <=
              _cacheValidityDuration) {
        return cachedResult.result;
      }

      // Rate limiting check
      if (_isRateLimited()) {
        return SafetyResult(
          url: url,
          status: SafetyStatus.error,
          threatType: AppConstants.rateLimitTitle,
          description: AppConstants.rateLimitMessage,
        );
      }

      // Record this request timestamp
      _requestTimestamps.add(DateTime.now());

      // Default to safe status
      SafetyStatus status = SafetyStatus.safe;
      String threatType = '';
      String description = '';

      // Check for HTTPS
      if (uri.scheme != 'https') {
        status = SafetyStatus.warning;
        threatType = AppConstants.insecureConnectionTitle;
        description = AppConstants.insecureConnectionMessage;
      }

      // Check for suspicious keywords in domain
      if (AppConstants.suspiciousKeywords.any((keyword) =>
          uri.host.toLowerCase().contains(keyword.toLowerCase()))) {
        status = SafetyStatus.warning;
        threatType = AppConstants.suspiciousDomainTitle;
        description = AppConstants.suspiciousDomainMessage;
      }

      try {
        // Attempt to fetch headers with timeout
        final response = await http.head(
          uri,
          headers: {'User-Agent': 'SafeScan/1.0'},
        ).timeout(AppConstants.urlCheckTimeout);

        // Check status code
        if (response.statusCode >= 400) {
          status = SafetyStatus.unsafe;
          threatType = AppConstants.invalidUrlTitle;
          description =
              '${AppConstants.invalidUrlMessage}: ${response.statusCode}';
        }
      } on TimeoutException {
        status = SafetyStatus.warning;
        threatType = AppConstants.timeoutTitle;
        description = AppConstants.timeoutMessage;
      } on http.ClientException catch (e) {
        status = SafetyStatus.error;
        threatType = AppConstants.connectionErrorTitle;
        description = '${AppConstants.connectionErrorMessage}: ${e.message}';
      } catch (e) {
        status = SafetyStatus.error;
        threatType = AppConstants.errorTitle;
        description = '${AppConstants.errorMessage}: ${e.toString()}';
      }

      final result = SafetyResult(
        url: url,
        status: status,
        threatType: threatType,
        description:
            description.isEmpty ? AppConstants.safeMessage : description,
      );

      // Cache the result
      _cache[cacheKey] = _CacheEntry(result);
      _cleanCache();

      return result;
    } catch (e) {
      return SafetyResult(
        url: url,
        status: SafetyStatus.error,
        threatType: AppConstants.invalidUrlFormatTitle,
        description: '${AppConstants.invalidUrlFormatMessage}: ${e.toString()}',
      );
    }
  }
}

class _CacheEntry {
  final SafetyResult result;
  final DateTime timestamp;

  _CacheEntry(this.result) : timestamp = DateTime.now();
}
