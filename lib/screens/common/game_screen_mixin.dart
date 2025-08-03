import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';
import 'package:flutter_online_cardgame/repository/firebase_repository.dart';

mixin GameScreenMixin {
  String get uid => FirebaseRepository.user.uid;

  GameInfo get gameInfo;
  GameState get gameState;
  GameConfig? get gameConfig;

  List<PlayerState> get activePlayers => gameState.activePlayers;
  PlayerInfo? get myInfo => gameConfig == null ? null : gameConfig!.playerInfo[uid];
  PlayerInfo? get gameMaster => gameConfig?.gameMaster(activePlayers);
  bool get isMaster => gameMaster == null ? false : gameMaster!.id == uid;

  /// Common error handling for API calls
  void handleApiError(String operation, dynamic error) {
    debugPrint('Error during $operation: $error');
    FirebaseCrashlytics.instance.recordError(
      error,
      StackTrace.current,
      reason: 'API Error during $operation',
    );
  }

  /// Common exit game functionality
  Future<void> exitGame() async {
    try {
      await FirebaseRepository.exitGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('exit game', e);
    }
  }

  /// Common end game functionality (admin only)
  Future<void> endGame() async {
    try {
      await FirebaseRepository.endGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('end game', e);
    }
  }

  /// Common reset game functionality (admin only)
  Future<void> resetGame() async {
    try {
      await FirebaseRepository.resetGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('reset game', e);
    }
  }
}
