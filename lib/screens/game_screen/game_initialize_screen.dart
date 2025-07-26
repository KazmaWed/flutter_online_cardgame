import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/common/progress_screen.dart';
import 'package:flutter_online_cardgame/screens/common/error_screen.dart';
import 'package:flutter_online_cardgame/screens/game_screen/game_screen.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';

class GameInitializeScreen extends StatelessWidget {
  final GameInfo gameInfo;
  const GameInitializeScreen({super.key, required this.gameInfo});

  @override
  Widget build(BuildContext context) {
    void onNoGameFound() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).popAndRemove(FadePageRoute(builder: (context) => TopScreen()));
      });
    }

    void onGameFound() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushReplacement(FadePageRoute(builder: (context) => GameScreen(gameInfo: gameInfo)));
      });
    }

    return BaseScaffold(
      body: FutureBuilder(
        future: FunctionsRepository.getGameConfig(gameId: gameInfo.gameId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return ErrorScreen(message: "No data obtained from server");
          }

          final response = snapshot.data;

          if (response == null) {
            onNoGameFound();
          } else {
            onGameFound();
          }

          return ProgressScreen();
        },
      ),
    );
  }
}
