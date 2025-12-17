import 'package:web/web.dart' as web;

/// Simple cookie-based key/value storage for Flutter Web builds.
class CookieRepository {
  CookieRepository._();

  static const _defaultPath = '/';

  /// Saves [value] for [key] in browser cookies.
  ///
  /// Optionally set [maxAge] to control how long the cookie lives.
  static void save({
    required String key,
    required String value,
    String path = _defaultPath,
    Duration maxAge = const Duration(days: 3),
  }) {
    final encodedValue = Uri.encodeComponent(value);
    final buffer = StringBuffer('$key=$encodedValue; path=$path');
    buffer.write('; max-age=${maxAge.inSeconds}');

    web.document.cookie = buffer.toString();
  }

  /// Reads a cookie value for [key]. Returns `null` if not found.
  static String? read(String key) {
    return load()[key];
  }

  /// Returns all cookies as a key/value map.
  static Map<String, String> load() {
    final result = <String, String>{};

    final rawCookie = web.document.cookie;
    if (rawCookie.isEmpty) return result;

    for (final entry in rawCookie.split('; ')) {
      if (entry.isEmpty) continue;
      final idx = entry.indexOf('=');
      if (idx <= 0) continue;

      final cookieKey = entry.substring(0, idx);
      final cookieValue = entry.substring(idx + 1);
      result[cookieKey] = Uri.decodeComponent(cookieValue);
    }
    return result;
  }

  /// Deletes the cookie for [key].
  static void delete(String key, {String path = _defaultPath}) {
    web.document.cookie = '$key=; path=$path; max-age=0';
  }
}
