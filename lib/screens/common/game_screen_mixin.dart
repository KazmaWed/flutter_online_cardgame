import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';

mixin GameScreenMixin {
  String get uid => FunctionsRepository.user.uid;

  GameInfo get gameInfo;
  GameState get gameState;
  GameConfig? get gameConfig;

  List<PlayerState> get activePlayers => gameState.activePlayers;
  PlayerInfo? get myInfo => gameConfig == null ? null : gameConfig!.playerInfo[uid];
  PlayerInfo? get gameMaster => gameConfig?.gameMaster(activePlayers);
  bool get isMaster => gameMaster == null ? false : gameMaster!.id == uid;

  /// Common error handling for API calls
  void handleApiError(String operation, dynamic error) {
    // TODO: Implement proper error handling
    debugPrint('Error during $operation: $error');
  }

  /// Common exit game functionality
  Future<void> exitGame() async {
    try {
      await FunctionsRepository.exitGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('exit game', e);
    }
  }

  /// Common end game functionality (admin only)
  Future<void> endGame() async {
    try {
      await FunctionsRepository.endGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('end game', e);
    }
  }

  /// Common reset game functionality (admin only)
  Future<void> resetGame() async {
    try {
      await FunctionsRepository.resetGame(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('reset game', e);
    }
  }
}
