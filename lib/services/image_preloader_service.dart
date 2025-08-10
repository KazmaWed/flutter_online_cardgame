import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/constants/app_assets.dart';

class ImagePreloaderService {
  static bool _isPreloaded = false;
  static bool get isPreloaded => _isPreloaded;

  static Future<void> preloadAllImages(BuildContext context) async {
    if (_isPreloaded) return;

    final List<Future<void>> preloadFutures = [];

    // Preload the locale-specific logo
    preloadFutures.add(precacheImage(AssetImage(AppAssets.logoForLocale(context)), context));

    for (int i = 0; i < 12; i++) {
      preloadFutures.add(precacheImage(AssetImage(AppAssets.avatar(i)), context));
    }

    // Preload instruction images using AppAssets
    for (int i = 0; i < 4; i++) {
      final instructionImage = AppAssets.instructionImage(i, context);
      preloadFutures.add(precacheImage(AssetImage(instructionImage), context));
    }

    try {
      await Future.wait(preloadFutures);
      _isPreloaded = true;
    } catch (e) {
      debugPrint('Error preloading images: $e');
    }
  }

  static Future<void> preloadAvatarImages(BuildContext context) async {
    final List<Future<void>> preloadFutures = [];

    for (int i = 0; i < 12; i++) {
      preloadFutures.add(precacheImage(AssetImage(AppAssets.avatar(i)), context));
    }

    try {
      await Future.wait(preloadFutures);
    } catch (e) {
      debugPrint('Error preloading avatar images: $e');
    }
  }

  static Future<void> preloadInstructionImages(BuildContext context) async {
    final List<Future<void>> preloadFutures = [];

    // Preload instruction images using AppAssets
    for (int i = 0; i < 4; i++) {
      final instructionImage = AppAssets.instructionImage(i, context);
      preloadFutures.add(precacheImage(AssetImage(instructionImage), context));
    }

    try {
      await Future.wait(preloadFutures);
    } catch (e) {
      debugPrint('Error preloading instruction images: $e');
    }
  }
}
