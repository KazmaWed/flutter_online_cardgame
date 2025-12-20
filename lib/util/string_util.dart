import 'dart:convert';
import 'package:crypto/crypto.dart';

extension StringExtension on String {
  /// Returns a substring of the string, or the entire string if the length is less than or equal to [length].
  int generateInt({int min = 1, int max = 100}) {
    // String → SHA256 hash
    final bytes = utf8.encode(this);
    final digest = sha256.convert(bytes);
    // digestの一部（最初の8バイト）をintに変換
    final bigInt = BigInt.parse(digest.toString().substring(0, 16), radix: 16);
    // 範囲内に収める
    final range = max - min + 1;
    return min + (bigInt.toInt().abs() % range);
  }

  String toNameString() => (trim().isEmpty) ? 'ナナシ' : this;
  String toHintString() => (trim().isEmpty) ? 'ヒントなし' : this;

  String withPin(String pin) {
    final pinStr = pin.toString().padLeft(4, '0');

    // Parse the current URL
    final uri = Uri.parse(this);

    // Extract language from path or query parameter
    String? langCode;
    if (uri.pathSegments.isNotEmpty) {
      final firstSegment = uri.pathSegments.first.toLowerCase();
      if (firstSegment == 'jp' || firstSegment == 'ja') {
        langCode = 'ja';
      } else {
        langCode = 'en';
      }
    }
    // Fallback to query parameter if no path language
    langCode ??= uri.queryParameters['lang'];

    // Preserve existing query parameters (e.g., campaign codes) but remove 'lang'
    final queryParameters = Map<String, String>.from(uri.queryParameters);
    queryParameters.remove('lang');
    queryParameters['pin'] = pinStr;

    // Build path with language code if present
    final pathSegments = langCode != null ? [langCode] : <String>[];

    // Create a new URI with language in path
    final newUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      pathSegments: pathSegments,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    return newUri.toString();
  }

  String removePin() {
    final uri = Uri.parse(this);
    if (!uri.queryParameters.containsKey('pin')) return toString();

    final params = Map<String, String>.from(uri.queryParameters)..remove('pin');
    final updated = uri.replace(queryParameters: params.isEmpty ? {} : params).toString();
    return updated.endsWith('?') ? updated.substring(0, updated.length - 1) : updated;
  }

  /// Converts avatar filename (e.g., "avatar01.jpg") to zero-based index (0).
  /// Returns 0 if the filename doesn't match the expected pattern.
  int toAvatarIndex() {
    final match = RegExp(r'avatar(\d{2})\.jpg$').firstMatch(this);
    return match == null ? 0 : int.parse(match.group(1)!) - 1;
  }

  /// Normalizes URL to have language code in path (e.g., /ja or /en)
  /// Returns normalized URL string
  String normalizeLanguagePath(String localeCode) {
    final uri = Uri.parse(this);

    // Extract language from path or query parameter
    String? langCode;
    if (uri.pathSegments.isNotEmpty) {
      final firstSegment = uri.pathSegments.first.toLowerCase();
      if (firstSegment == 'jp' || firstSegment == 'ja') {
        langCode = 'ja';
      } else {
        langCode = 'en';
      }
    }
    langCode ??= uri.queryParameters['lang'];
    langCode ??= localeCode == 'en' ? 'en' : 'ja';

    // Create normalized URI
    final pathSegments = [langCode];

    // Preserve existing query parameters
    final queryParameters = Map<String, String>.from(uri.queryParameters);
    queryParameters.remove('lang');

    final newUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      pathSegments: pathSegments,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    return newUri.toString();
  }
}

extension IntExtension on int {
  /// Returns the ordinal suffix for English numbers (1st, 2nd, 3rd, 4th, etc.)
  String get ordinalSuffix {
    // Handle special cases for 11th, 12th, 13th
    if (this >= 11 && this <= 13) {
      return 'th';
    }

    // Handle regular cases based on last digit
    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Returns the number with ordinal suffix (1st, 2nd, 3rd, etc.)
  String get ordinal => '$this$ordinalSuffix';
}
