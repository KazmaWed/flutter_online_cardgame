import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';

class GameResult {
  final String playerId;
  final String topic;
  final List<PlayerResult> playerResults;
  final Map<String, int> values;

  GameResult({
    required this.playerId,
    required this.topic,
    required this.playerResults,
    required this.values,
  });

  factory GameResult.create({
    required String playerId,
    required GameState gameState,
    required GameConfig gameConfig,
    required Map<String, int> values,
  }) {
    try {
      final playerResults = gameState.submittedPlayers.map((player) {
        final playerInfo = gameConfig.playerInfo[player.id]!;
        final submittedOrder = gameState.submittedOrderOf(playerInfo);
        final correctOrder = gameState.correctOrderMap(values)?[player.id] ?? 0;

        return PlayerResult(
          name: playerInfo.name,
          avatar: playerInfo.avatar,
          hint: player.hint,
          value: values[player.id]!,
          index: correctOrder,
          submitted: submittedOrder!,
          avatarFileName: playerInfo.avatarFileName,
        );
      }).toList();
      // final score = game.score ?? 0;

      return GameResult(
        playerId: playerId,
        topic: gameConfig.topic,
        playerResults: playerResults,
        values: values,
      );
    } catch (e) {
      // Handle any errors that may occur during result creation
      throw Exception('Error creating game result: $e');
    }
  }

  int get score => playerResults.where((result) => result.isCorrect).length;

  bool get perfectGame => playerResults.every((result) => result.isCorrect);
}

class PlayerResult {
  final String name;
  final int avatar;
  final String hint;
  final int value;
  final int submitted;
  final int index;
  final String avatarFileName;

  PlayerResult({
    required this.value,
    required this.hint,
    required this.avatar,
    required this.name,
    required this.index,
    required this.submitted,
    required this.avatarFileName,
  });

  bool get isCorrect => submitted == index;
}
