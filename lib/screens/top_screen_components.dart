import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/constants/app_assets.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';

class GameTitleWidget extends StatelessWidget {
  final String title;
  const GameTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: AppDimentions.screenWidth,
        padding: const EdgeInsets.all(AppDimentions.paddingLarge),
        child: Image.asset(AppAssets.logoForLocale(context), fit: BoxFit.cover),
      ),
    );
  }
}

class GameMenuWidget extends StatelessWidget {
  final VoidCallback onCreateGame;
  final VoidCallback onJoinGame;
  final VoidCallback onHowToPlay;

  const GameMenuWidget({
    super.key,
    required this.onCreateGame,
    required this.onJoinGame,
    required this.onHowToPlay,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final createGameLabel = l10n.createNewGame;
    final joinGameLabel = l10n.joinGame;
    final howToPlayLabel = l10n.howToPlay;

    return Column(
      spacing: AppDimentions.paddingSmall,
      children: [
        Row(
          spacing: AppDimentions.paddingSmall,
          children: [
            Expanded(
              child: RectangularRowButton(onPressed: onCreateGame, label: createGameLabel),
            ),
            Expanded(
              child: RectangularRowButton(onPressed: onJoinGame, label: joinGameLabel),
            ),
          ],
        ),
        RectangularTextButton(onPressed: onHowToPlay, label: howToPlayLabel),
      ],
    );
  }
}
