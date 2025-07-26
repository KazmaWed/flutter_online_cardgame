import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/constants/app_images.dart';

class ImagePreloaderService {
  static bool _isPreloaded = false;
  static bool get isPreloaded => _isPreloaded;

  static Future<void> preloadAllImages(BuildContext context) async {
    if (_isPreloaded) return;

    final List<Future<void>> preloadFutures = [];

    preloadFutures.add(precacheImage(AssetImage(AppImages.logo), context));

    for (int i = 0; i < 12; i++) {
      preloadFutures.add(precacheImage(AssetImage(AppImages.avatar(i)), context));
    }

    for (int i = 0; i < 4; i++) {
      final instructionImage = 'assets/images/instruction${i.toString().padLeft(2, '0')}.png';
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
      preloadFutures.add(precacheImage(AssetImage(AppImages.avatar(i)), context));
    }

    try {
      await Future.wait(preloadFutures);
    } catch (e) {
      debugPrint('Error preloading avatar images: $e');
    }
  }

  static Future<void> preloadInstructionImages(BuildContext context) async {
    final List<Future<void>> preloadFutures = [];

    for (int i = 0; i < 4; i++) {
      final instructionImage = 'assets/images/instruction${i.toString().padLeft(2, '0')}.png';
      preloadFutures.add(precacheImage(AssetImage(instructionImage), context));
    }

    try {
      await Future.wait(preloadFutures);
    } catch (e) {
      debugPrint('Error preloading instruction images: $e');
    }
  }
}
