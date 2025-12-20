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

      // Check path segments (e.g., /jp, /en)
      final pathSegments = uri.pathSegments;
      String? langFromPath;
      if (pathSegments.isNotEmpty) {
        final firstSegment = pathSegments.first.toLowerCase();
        if (firstSegment == 'jp' || firstSegment == 'ja') {
          langFromPath = 'ja';
        } else if (firstSegment == 'en') {
          langFromPath = 'en';
        }
      }
      // Check query parameters (e.g., ?lang=ja, ?lang=en)
      final langParam = uri.queryParameters['lang'];

      final languageCode = langFromPath ?? langParam;
      if (languageCode != null) {
        // URL parameter takes precedence
        switch (languageCode.toLowerCase()) {
          case 'ja':
            state = const Locale('ja');
            break;
          case 'en':
            state = const Locale('en');
            break;
          default:
            break;
        }
      } else {
        // No URL parameter, use browser locale detection
        final browserLocale = ui.PlatformDispatcher.instance.locale;
        if (browserLocale.languageCode == 'ja') {
        } else {
          state = const Locale('en');
        }
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
