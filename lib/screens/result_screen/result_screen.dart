import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_result.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/common/progress_screen.dart';
import 'package:flutter_online_cardgame/screens/common/error_screen.dart';
import 'package:flutter_online_cardgame/screens/result_screen/result_screen_components.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';

class ResultScreen extends StatefulWidget {
  final GameInfo gameInfo;
  final GameState gameState;

  const ResultScreen({super.key, required this.gameInfo, required this.gameState});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _busy = false;
  bool _isLoading = true;
  String? _error;
  dynamic _gameConfigResponse;

  @override
  void initState() {
    super.initState();
    _loadGameConfig();
  }

  Future<void> _loadGameConfig() async {
    try {
      final response = await FunctionsRepository.getGameConfig(gameId: widget.gameInfo.gameId);
      if (mounted) {
        setState(() {
          _gameConfigResponse = response;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void onRestartPressed() async {
    if (_busy) return;

    try {
      setState(() => _busy = true);
      await FunctionsRepository.resetGame(gameId: widget.gameInfo.gameId);
    } catch (e) {
      // TODO: Handle error appropriately
      debugPrint('Error restarting game: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void onBackPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        title: Text(l10n.confirmExitGameTitle),
        content: Text(l10n.confirmExitGameMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.exitGame)),
        ],
      ),
    );

    if (shouldExit != true) return;

    if (mounted) {
      await Navigator.of(context).popAndRemove(FadePageRoute(builder: (context) => TopScreen()));
    }
    try {
      await FunctionsRepository.exitGame(gameId: widget.gameInfo.gameId);
    } catch (e) {
      debugPrint('Error exiting game: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // While fetching game config
    if (_isLoading) {
      return BaseScaffold(body: ProgressScreen());
    }

    // If there was an error fetching game config
    if (_error != null) {
      return BaseScaffold(body: ErrorScreen(message: _error!));
    }

    // If game config couldn't be fetched
    if (_gameConfigResponse == null) {
      return BaseScaffold(body: ErrorScreen(message: "No data obtained from server"));
    }

    final response = _gameConfigResponse!;
    final values = response.values;
    final gameConfig = response.config;
    final gameMaster = gameConfig.gameMaster(widget.gameState.activePlayers);
    final isMaster = gameMaster?.id == FunctionsRepository.user.uid;

    final result = GameResult.create(
      playerId: FunctionsRepository.user.uid,
      gameState: widget.gameState,
      gameConfig: gameConfig,
      values: values,
    );

    return BarrierContainer(
      showBarrier: _busy,
      child: BaseScaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBackPressed),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimentions.paddingMicro,
          children: [
            ScoreWidget(result: result),
            PlayerResultsWidget(result: result),
            if (isMaster)
              RectangularTextButton(onPressed: onRestartPressed, label: l10n.startNewGame),
          ],
        ),
      ),
    );
  }
}
