import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_phase.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';

class GameState {
  final GamePhase phase;
  final GameConfig? config; // Only exists when phase == 0
  final Map<String, PlayerState> playerState;

  GameState({required this.phase, this.config, required this.playerState});

  factory GameState.fromJson(Map<String, dynamic> json) {
    try {
      final phase = json['phase'] as int? ?? 0;

      // Parse config (only exists when phase == 0)
      GameConfig? config;
      if (json['config'] != null && json['config'] is Map) {
        final configData = json['config'] as Map;
        final configMap = Map<String, dynamic>.from(
          configData.map((key, value) => MapEntry(key.toString(), value)),
        );
        config = GameConfig.fromJson(configMap);
      }

      // Parse playerState
      final playerStateMap = <String, PlayerState>{};
      if (json['playerState'] is Map) {
        (json['playerState'] as Map).forEach((playerId, playerData) {
          try {
            final playerMap = Map<String, dynamic>.from(
              (playerData as Map).map((key, value) => MapEntry(key.toString(), value)),
            );
            playerStateMap[playerId.toString()] = PlayerState.fromJson({
              'id': playerId.toString(),
              ...playerMap,
            });
          } catch (e) {
            debugPrint('Error parsing player $playerId: $e');
            rethrow;
          }
        });
      }

      return GameState(
        phase: GamePhaseExtension.fromInt(phase),
        config: config,
        playerState: playerStateMap,
      );
    } catch (e) {
      throw FormatException('Invalid JSON format for GameState: $e');
    }
  }

  @override
  String toString() {
    return 'GameState('
        'phase: $phase, '
        'config: $config, '
        'playerState: $playerState'
        ')';
  }

  List<PlayerState> get activePlayers =>
      playerState.values.where((state) => state.isActive).toList();

  List<PlayerInfo> get activePlayersInfo => config!.playerInfo.values.activePlayers(playerState);

  int? submittedOrderOf(PlayerInfo player) => activePlayers.submittedOrderOf(player);

  Map<String, int>? correctOrderMap(Map<String, int> values) {
    final List<String> activePlayerIds = activePlayers
        .where((player) => player.isActive)
        .map((player) => player.id)
        .toList();
    final Map<String, int> valuesFiltered = Map.fromEntries(
      values.entries.where((e) => activePlayerIds.contains(e.key)),
    );
    final List<int> valuesSorted = valuesFiltered.values.toList()..sort();

    // Create ranking map where rank is based on value position
    final map = Map.fromEntries(
      activePlayers.map((player) {
        final playerValue = values[player.id]!;
        final rank = valuesSorted.indexOf(playerValue) + 1;
        return MapEntry(player.id, rank);
      }),
    );
    return map;
  }

  List<PlayerState> get submittedPlayers => activePlayers.submittedPlayers;
  List<PlayerState> get pendingPlayers => activePlayers.pendingPlayers;
  bool get allSubmitted => submittedPlayers.length == activePlayers.length;
}
