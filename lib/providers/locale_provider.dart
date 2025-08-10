import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_getInitialLocale()) {
    _initializeLocale();
  }

  static Locale _getInitialLocale() {
    // Get browser locale as default
    if (kIsWeb) {
      final browserLocale = ui.PlatformDispatcher.instance.locale;
      if (browserLocale.languageCode == 'en') {
        return const Locale('en');
      }
    }
    // Default to Japanese for all other cases
    return const Locale('ja');
  }

  void _initializeLocale() {
    if (kIsWeb) {
      final uri = Uri.base;
      final langParam = uri.queryParameters['lang'];
      
      if (langParam != null) {
        // URL parameter takes precedence
        switch (langParam.toLowerCase()) {
          case 'en':
          case 'english':
            state = const Locale('en');
            break;
          case 'ja':
          case 'japanese':
          case 'jp':
            state = const Locale('ja');
            break;
          default:
            // Keep current state (browser detected or default)
            break;
        }
      } else {
        // No URL parameter, use browser locale detection
        final browserLocale = ui.PlatformDispatcher.instance.locale;
        if (browserLocale.languageCode == 'en') {
          state = const Locale('en');
        } else if (browserLocale.languageCode == 'ja') {
          state = const Locale('ja');
        }
        // For other languages, keep default Japanese locale
      }
    }
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLanguage() {
    if (state.languageCode == 'ja') {
      state = const Locale('en');
    } else {
      state = const Locale('ja');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});