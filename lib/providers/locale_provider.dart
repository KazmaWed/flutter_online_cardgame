import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(_getInitialLocale()) {
    _initializeLocale();
  }

  static Locale _getInitialLocale() {
    // Get browser locale as default
    if (kIsWeb) {
      final browserLocale = ui.PlatformDispatcher.instance.locale;
      // Japanese if locale is ja or jp, otherwise English
      final langCode = browserLocale.languageCode.toLowerCase();
      if (AppConstants.japaneseCodes.contains(langCode)) {
        return const Locale(AppConstants.japaneseCode);
      } else {
        return const Locale(AppConstants.englishCode);
      }
    }
    // Default to Japanese for non-web platforms
    return const Locale(AppConstants.japaneseCode);
  }

  void _initializeLocale() {
    if (kIsWeb) {
      final uri = Uri.base;

      // Check path segments (e.g., /jp, /en)
      final pathSegments = uri.pathSegments;
      String? langFromPath;
      if (pathSegments.isNotEmpty) {
        final firstSegment = pathSegments.first.toLowerCase();
        if (AppConstants.japaneseCodes.contains(firstSegment)) {
          langFromPath = AppConstants.japaneseCode;
        } else if (firstSegment == AppConstants.englishCode) {
          langFromPath = AppConstants.englishCode;
        }
      }
      // Check query parameters (e.g., ?lang=ja, ?lang=jp, ?lang=en)
      String? langFromQuery;
      final langParam = uri.queryParameters[AppConstants.queryParamLang]?.toLowerCase();
      if (AppConstants.japaneseCodes.contains(langParam)) {
        langFromQuery = AppConstants.japaneseCode;
      } else if (langParam == AppConstants.englishCode) {
        langFromQuery = AppConstants.englishCode;
      }

      final languageCode = langFromPath ?? langFromQuery;
      if (languageCode != null) {
        // URL parameter takes precedence
        switch (languageCode.toLowerCase()) {
          case AppConstants.japaneseCode:
            state = const Locale(AppConstants.japaneseCode);
            break;
          case AppConstants.englishCode:
            state = const Locale(AppConstants.englishCode);
            break;
          default:
            break;
        }
      } else {
        // No URL parameter, use browser locale detection
        final browserLocale = ui.PlatformDispatcher.instance.locale;
        final langCode = browserLocale.languageCode.toLowerCase();
        if (AppConstants.japaneseCodes.contains(langCode)) {
          // Keep default ja
        } else {
          state = const Locale(AppConstants.englishCode);
        }
      }
    }
  }

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLanguage() {
    if (state.languageCode == AppConstants.japaneseCode) {
      state = const Locale(AppConstants.englishCode);
    } else {
      state = const Locale(AppConstants.japaneseCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
