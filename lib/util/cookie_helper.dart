import 'package:flutter_online_cardgame/repository/cookie_repository.dart';

/// Provides semantic helpers for reading/writing showcase cookie flags.
class CookieHelper {
  CookieHelper._();

  static const _showcasedMatchingScreen = 'showcasedMatchingScreen';
  static const _showcasedMatchingScreenAsMaster = 'showcasedMatchingScreenAsMaster';
  static const _showcasedGameScreen = 'showcasedGameScreen';

  /// Returns true if the player showcase has already been displayed for the provided uid.
  static bool hasShowcasedMatchingScreen(String uid) =>
      CookieRepository.read(_showcasedMatchingScreen) == uid;

  /// Returns true if the master showcase has already been displayed for the provided uid.
  static bool hasShowcasedMatchingScreenAsMaster(String uid) =>
      CookieRepository.read(_showcasedMatchingScreenAsMaster) == uid;

  /// Returns true if the player showcase on the game screen has already been displayed for the provided uid.
  static bool hasShowcasedGameScreen(String uid) =>
      CookieRepository.read(_showcasedGameScreen) == uid;

  /// Marks the player showcase as shown for the provided uid.
  static void markShowcasedMatchingScreen(String uid) =>
      CookieRepository.save(key: _showcasedMatchingScreen, value: uid);

  /// Marks the master showcase as shown for the provided uid.
  static void markShowcasedMatchingScreenAsMaster(String uid) =>
      CookieRepository.save(key: _showcasedMatchingScreenAsMaster, value: uid);

  /// Marks the player game screen showcase as shown for the provided uid.
  static void markShowcasedGameScreen(String uid) =>
      CookieRepository.save(key: _showcasedGameScreen, value: uid);
}
