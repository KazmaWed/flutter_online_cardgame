import 'package:flutter_online_cardgame/repository/cookie_repository.dart';

/// Provides semantic helpers for reading/writing showcase cookie flags.
class CookieHelper {
  CookieHelper._();

  static const _showcasedMatchingScreen = 'showcasedMatchingScreen';
  static const _showcasedMatchingScreenAsMaster = 'showcasedMatchingScreenAsMaster';
  static const _showcasedGameScreen = 'showcasedGameScreen';
  static const _showcasedGameScreenAsMaster = 'showcasedGameScreenAsMaster';

  /// Returns true if the player showcase has already been displayed.
  static bool hasShowcasedMatchingScreen() =>
      CookieRepository.read(_showcasedMatchingScreen)?.toLowerCase() == 'true';

  /// Returns true if the master showcase has already been displayed.
  static bool hasShowcasedMatchingScreenAsMaster() =>
      CookieRepository.read(_showcasedMatchingScreenAsMaster)?.toLowerCase() == 'true';

  /// Returns true if the player showcase on the game screen has already been displayed.
  static bool hasShowcasedGameScreen() =>
      CookieRepository.read(_showcasedGameScreen)?.toLowerCase() == 'true';

  /// Returns true if the master showcase on the game screen has already been displayed.
  static bool hasShowcasedGameScreenAsMaster() =>
      CookieRepository.read(_showcasedGameScreenAsMaster)?.toLowerCase() == 'true';

  /// Marks the player showcase as shown.
  static void markShowcasedMatchingScreen() =>
      CookieRepository.save(key: _showcasedMatchingScreen, value: 'true');

  /// Marks the master showcase as shown.
  static void markShowcasedMatchingScreenAsMaster() =>
      CookieRepository.save(key: _showcasedMatchingScreenAsMaster, value: 'true');


  /// Marks the player game screen showcase as shown.
  static void markShowcasedGameScreen() =>
      CookieRepository.save(key: _showcasedGameScreen, value: 'true');

  /// Marks the master game screen showcase as shown.
  static void markShowcasedGameScreenAsMaster() =>
      CookieRepository.save(key: _showcasedGameScreenAsMaster, value: 'true');
}
