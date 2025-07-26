import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';

class GameConfig {
  final String topic;
  final Map<String, PlayerInfo> playerInfo;

  GameConfig({required this.topic, required this.playerInfo});

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    final topic = json['topic'] as String? ?? '';

    Map<String, PlayerInfo> playerInfo = {};
    if (json['playerInfo'] != null && json['playerInfo'] is Map) {
      final playerInfoData = json['playerInfo'] as Map;
      playerInfo = playerInfoData.map((key, value) {
        final playerMap = Map<String, dynamic>.from(
          (value as Map).map((k, v) => MapEntry(k.toString(), v)),
        );
        playerMap['id'] = key.toString();
        // Add playerId to the player data
        playerMap['playerId'] = key.toString();
        return MapEntry(key.toString(), PlayerInfo.fromJson(playerMap));
      });
    }

    return GameConfig(topic: topic, playerInfo: playerInfo);
  }

  /// Returns the game master (player with earliest entrance time)
  PlayerInfo? gameMaster(List<PlayerState> activePlayers) {
    if (activePlayers.isEmpty) return null;
    if (activePlayers.length == 1) return playerInfo[activePlayers.first.id]!;

    final activePlayerIds = activePlayers.map((e) => e.id).toList();
    final playerInfos = playerInfo.values.toList();
    playerInfos.sort((a, b) => a.entrance.compareTo(b.entrance));

    final first = playerInfos.firstWhere((p) => activePlayerIds.contains(p.id));
    return first;
  }

  List<PlayerInfo> guestPlayers(List<PlayerState> activePlayers) {
    if (activePlayers.isEmpty || activePlayers.length == 1) return [];

    final gm = gameMaster(activePlayers);
    if (gm == null) return playerInfo.values.toList();
    return playerInfo.values
        .where((p) => p.id != gm.id && activePlayers.any((s) => s.id == p.id))
        .toList();
  }

  @override
  String toString() {
    return 'GameConfig('
        'topic: $topic, '
        'playerInfo: $playerInfo'
        ')';
  }
}

// class GameConfig {
//   final String gameId;
//   final String password;
//   final String topic;
//   final Map<String, DateTime> playerEntrance;
//   final Map<String, int> values;

//   GameConfig({
//     required this.gameId,
//     required this.password,
//     required this.topic,
//     required this.playerEntrance,
//     required this.values,
//   });

//   factory GameConfig.fromJson(Map<String, dynamic> json) {
//     // TODO: パース失敗時の処理
//     final valuesJson = json['values'] as Map<String, dynamic>? ?? <String, int>{};
//     final configJson = json['config'] as Map<String, dynamic>? ?? {};
//     final gameId = configJson['gameId'] as String? ?? '';
//     final values = valuesJson.map(
//       (key, value) => MapEntry(key.toString(), value is int ? value : 0),
//     );
//     final playerEntrance = <String, DateTime>{};
//     if (configJson['playerEntrance'] is Map) {
//       (configJson['playerEntrance'] as Map).forEach((key, value) {
//         playerEntrance[key.toString()] = DateTime.fromMillisecondsSinceEpoch(value);
//       });
//     }
//     return GameConfig(
//       gameId: gameId,
//       password: configJson['password'] as String? ?? '0000',
//       topic: configJson['topic'] as String? ?? '',
//       playerEntrance: playerEntrance,
//       values: values,
//     );
//   }

//   @override
//   String toString() {
//     return 'GameConfig(password: $password, topic: $topic, playerEntrance: $playerEntrance, values: $values)';
//   }
// }
