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

    // Create a new URI with only the scheme, port, and host (no path, no hash)
    final baseUri = Uri(scheme: uri.scheme, host: uri.host, port: uri.port);

    // Add the pin query parameter
    final newUri = baseUri.replace(queryParameters: {'pin': pinStr});

    return newUri.toString();
  }
}
