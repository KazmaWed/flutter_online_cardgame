import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/components/avatar_container.dart';
import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/common/game_screen_mixin.dart';
import 'package:flutter_online_cardgame/screens/common/progress_screen.dart';
import 'package:flutter_online_cardgame/screens/playing_screen/playing_screen_components.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

class PlayingScreen extends StatefulWidget {
  final GameInfo gameInfo;
  final GameState gameState;
  const PlayingScreen({super.key, required this.gameInfo, required this.gameState});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> with GameScreenMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late GameConfig _gameConfig;

  @override
  GameInfo get gameInfo => widget.gameInfo;
  @override
  GameState get gameState => widget.gameState;
  @override
  GameConfig get gameConfig => _gameConfig;

  int? _value;

  bool _busy = false;

  Future<void> _loadGameConfig() async {
    try {
      final response = await FunctionsRepository.getGameConfig(gameId: gameInfo.gameId);
      if (mounted) {
        setState(() {
          _gameConfig = response.config;
          _value = response.values.values.first;
        });
      }
    } catch (e) {
      handleApiError('load game config', e);
    }
  }

  void _onFocusChanged() {
    try {
      FunctionsRepository.updateHint(hint: _controller.text, gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('update hint', e);
    }
  }

  void _onSubmit() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await FunctionsRepository.submit(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('submit', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onWithdraw() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await FunctionsRepository.withdraw(gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('withdraw', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onBackPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmExitGameTitle),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        content: Text(l10n.confirmExitGameMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.exitGame)),
        ],
      ),
    );

    if (shouldExit != true) return;

    exitGame();
    if (mounted) {
      Navigator.of(context).popAndRemove(FadePageRoute(builder: (context) => TopScreen()));
    }
  }

  void _onEndGame() async {
    if (_busy) return;
    setState(() => _busy = true);

    try {
      await endGame();
    } catch (e) {
      handleApiError('end game', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onTapGameMasterMenu() {
    if (!isMaster) return;
    final l10n = AppLocalizations.of(context)!;
    var busy = false;

    void onTapPlayer(PlayerInfo playerInfo) async {
      if (!busy) {
        busy = true;
        try {
          await FunctionsRepository.kickPlayer(gameId: gameInfo.gameId, playerId: playerInfo.id);
        } catch (e) {
          handleApiError('kick player', e);
        } finally {
          busy = false;
          if (mounted) Navigator.of(context).pop();
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        title: Text(l10n.kickPlayerTitle),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activePlayers.isEmpty)
                Text(l10n.noPlayersMessage)
              else
                ...gameConfig
                    .guestPlayers(activePlayers)
                    .map(
                      (player) => ListTile(
                        leading: AvatarContainer(
                          fileName: player.avatarFileName,
                          size: AppDimentions.avatarSizeXS,
                        ),
                        title: Text(player.name.toNameString()),
                        subtitle: Text('ID: ${player.id}'),
                        onTap: () => onTapPlayer(player),
                      ),
                    ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadGameConfig();
    _controller.text = gameState.playerState[uid]?.hint ?? '';
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(PlayingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameState != widget.gameState) {
      _controller.text = gameState.playerState[uid]?.hint ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_value == null) return ProgressScreen();
    final value = _value!;

    bool gameOverEnabled = isMaster && gameState.allSubmitted;

    final submittedOrder = gameState.submittedOrderOf(myInfo!);
    bool submitEnabled = !_busy && submittedOrder == null;
    bool withdrawEnabled = !_busy && submittedOrder != null;
    String buttonText(AppLocalizations l10n) =>
        submittedOrder == null ? l10n.submit : l10n.submitOrderText(submittedOrder);

    return BarrierContainer(
      showBarrier: _busy,
      child: BaseScaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _onBackPressed),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppDimentions.paddingMicro,
            children: [
              TopicCardWidget(topic: gameConfig.topic),
              PlayerInfoWidget(
                submittedPlayers: gameState.submittedPlayers,
                pendingPlayers: gameState.pendingPlayers,
                playerInfoMap: gameConfig.playerInfo,
                me: myInfo!,
              ),
              SubmitWidget(
                controller: _controller,
                focusNode: _focusNode,
                me: myInfo!,
                value: value,
                topic: gameConfig.topic,
                submittedOrder: submittedOrder,
                buttonText: buttonText(l10n),
                submitEnabled: submitEnabled,
                withdrawEnabled: withdrawEnabled,
                onSubmit: _onSubmit,
                onWithdraw: _onWithdraw,
              ),
              if (isMaster)
                GameMasterWidget(
                  gameOverEnabled: gameOverEnabled,
                  onEndGame: _onEndGame,
                  onTapGameMasterMenu: _onTapGameMasterMenu,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
