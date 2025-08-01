import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/components/app_cycle_notifier_widget.dart';

import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_phase.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/common/progress_screen.dart';
import 'package:flutter_online_cardgame/screens/common/error_screen.dart';
import 'package:flutter_online_cardgame/screens/matching_screen/matching_screen.dart';
import 'package:flutter_online_cardgame/screens/playing_screen/playing_screen.dart';
import 'package:flutter_online_cardgame/screens/result_screen/result_screen.dart';

class GameScreen extends StatelessWidget {
  final GameInfo gameInfo;
  const GameScreen({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    // 結果画面更新のための変数
    GamePhase? currentPhase;
    GameState? resultGameState;

    return AppLifecycleHandlerWidget(
      gameId: gameInfo.gameId,
      child: Scaffold(
        body: StreamBuilder(
          stream: FunctionsRepository.watchGameState(gameInfo.gameId),
          builder: (context, snapshot) {
            // ゲーム終了中は接続しない
            if (FunctionsRepository.exitingGame) return const ProgressScreen();

            if (snapshot.connectionState == ConnectionState.waiting) return const ProgressScreen();
            if (snapshot.hasError) {
              debugPrint('Error fetching game: ${snapshot.error}');
              return ErrorScreen(message: snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return ErrorScreen(message: "No data obtained from server");
            }

            final gameState = snapshot.data;
            if (gameState == null) return ErrorScreen(message: 'No game data available');

            switch (gameState.phase) {
              case GamePhase.matching:
                resultGameState = null;
                child = MatchingScreen(gameInfo: gameInfo, gameState: gameState);
              case GamePhase.playing:
                child = PlayingScreen(gameInfo: gameInfo, gameState: gameState);
              case GamePhase.finished:
                final shouldUpdate = currentPhase != gameState.phase;
                if (shouldUpdate) {
                  resultGameState ??= gameState;
                  child = ResultScreen(gameInfo: gameInfo, gameState: resultGameState!);
                }
                break;
            }
            currentPhase = gameState.phase;
            return AnimatedSwitcher(duration: Durations.medium1, child: child);
          },
        ),
      ),
    );
  }
}
