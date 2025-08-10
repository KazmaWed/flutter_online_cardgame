import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

class LanguageUtil {
  /// Updates the URL with the specified language parameter
  static void updateUrlLanguage(String languageCode) {
    if (kIsWeb) {
      final uri = Uri.base;
      final newParams = Map<String, String>.from(uri.queryParameters);
      newParams['lang'] = languageCode;
      
      final newUri = uri.replace(queryParameters: newParams);
      // Note: In a real app, you might want to use browser history management
      // This is a basic implementation
      if (kDebugMode) {
        print('URL would be updated to: ${newUri.toString()}');
      }
    }
  }
  
  /// Gets the current language from URL parameters
  static String? getLanguageFromUrl() {
    if (kIsWeb) {
      return Uri.base.queryParameters['lang'];
    }
    return null;
  }

  /// Gets the browser's preferred language
  static String getBrowserLanguage() {
    if (kIsWeb) {
      final browserLocale = ui.PlatformDispatcher.instance.locale;
      return browserLocale.languageCode;
    }
    return 'ja'; // Default fallback
  }
  
  /// Gets the display name for a language code
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      default:
        return languageCode;
    }
  }
}