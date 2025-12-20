import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';

class AppAssets {
  // Avatar Images
  static String avatar(int id) => 'assets/images/avatar${(id + 1).toString().padLeft(2, '0')}.jpg';

  // Logo Images
  static String get logo => 'assets/images/logo.png';

  static String logoForLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode.toLowerCase();
    return AppConstants.japaneseCodes.contains(localeCode)
        ? 'assets/images/logo_jp.png'
        : 'assets/images/logo_en.png';
  }

  // Instruction Images
  static String instructionImage(int index, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode.toLowerCase();
    final suffix = AppConstants.japaneseCodes.contains(localeCode) ? '_jp' : '_en';
    return 'assets/images/instruction${(index + 1).toString().padLeft(2, '0')}$suffix.png';
  }

  // Instruction JSON Files
  static String instructionJson(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode.toLowerCase();
    return AppConstants.japaneseCodes.contains(localeCode)
        ? 'assets/instructions_jp.json'
        : 'assets/instructions_en.json';
  }

  // Topics JSON Files
  static String topicsJson(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode.toLowerCase();
    return AppConstants.japaneseCodes.contains(localeCode)
        ? 'assets/topics_jp.json'
        : 'assets/topics_en.json';
  }

  // Fallback paths
  static String get instructionJsonFallback => 'assets/instructions_jp.json';
  static String get topicsJsonFallback => 'assets/topics_jp.json';
}
