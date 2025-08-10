import 'package:flutter/material.dart';

class AppAssets {
  // Avatar Images
  static String avatar(int id) => 'assets/images/avatar${id.toString().padLeft(2, '0')}.jpg';

  // Logo Images
  static String get logo => 'assets/images/logo.png';

  static String logoForLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode;
    return localeCode == 'en' ? 'assets/images/logo_en.png' : 'assets/images/logo_jp.png';
  }

  // Instruction Images
  static String instructionImage(int index, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode;
    final suffix = localeCode == 'en' ? '_en' : '_jp';
    return 'assets/images/instruction${index.toString().padLeft(2, '0')}$suffix.png';
  }

  // Instruction JSON Files
  static String instructionJson(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode;
    return localeCode == 'en' ? 'assets/instructions_en.json' : 'assets/instructions_jp.json';
  }

  // Topics JSON Files
  static String topicsJson(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localeCode = locale.languageCode;
    return localeCode == 'en' 
        ? 'assets/topics_en.json'
        : 'assets/topics_jp.json';
  }

  // Fallback paths
  static String get instructionJsonFallback => 'assets/instructions_jp.json';
  static String get topicsJsonFallback => 'assets/topics_jp.json';
}
