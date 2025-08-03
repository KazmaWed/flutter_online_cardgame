import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/components/barrier_container.dart';

import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/constants/app_images.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/repository/firebase_repository.dart';
import 'package:flutter_online_cardgame/screens/common/game_screen_mixin.dart';
import 'package:flutter_online_cardgame/screens/matching_screen/matching_screen_components.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key, required this.gameInfo, required this.gameState});

  final GameInfo gameInfo;
  final GameState gameState;

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> with GameScreenMixin {
  final FocusNode _playerFocusNode = FocusNode();
  final FocusNode _topicFocusNode = FocusNode();

  bool _busy = false;

  @override
  GameInfo get gameInfo => widget.gameInfo;
  @override
  GameState get gameState => widget.gameState;
  @override
  GameConfig get gameConfig => gameState.config!;

  bool get _isStartButtonEnabled =>
      activePlayers.length >= 2 && isMaster && gameConfig.topic.isNotEmpty;

  void _onPlayerNameUpdated(String name) async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      await FirebaseRepository.updateName(name: name, gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('update player name', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onTapAvatar() {
    showDialog(
      context: context,
      builder: (context) => AvatarSelectDialog(onAvatarSelected: _onAvatarSelected),
    );
  }

  void _onAvatarSelected(String avatarFileName) async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      final match = RegExp(r'avatar(\d{2})\.jpg$').firstMatch(avatarFileName);
      final avatarIndex = match != null ? int.parse(match.group(1)!) : 0;
      await FirebaseRepository.updateAvatar(avatar: avatarIndex, gameId: gameInfo.gameId);
    } catch (e) {
      handleApiError('update player avatar', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onTopicUpdated(String topic) async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      await FirebaseRepository.updateTopic(gameId: gameInfo.gameId, topic: topic);
    } catch (e) {
      handleApiError('update topic', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onStartPressed() async {
    if (_busy || !_isStartButtonEnabled) return;
    try {
      setState(() => _busy = true);
      await FirebaseRepository.startGame(
        gameId: gameInfo.gameId,
        topic: gameConfig.topic,
        playerCount: activePlayers.length,
      );
    } catch (e) {
      handleApiError('start game', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onBackPressed() async {
    if (_busy) return;

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

    setState(() => _busy = true);
    try {
      exitGame();
      if (mounted) {
        Navigator.of(context).popAndRemove(FadePageRoute(builder: (context) => TopScreen()));
      }
    } catch (e) {
      debugPrint('Error exiting game: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _playerFocusNode.dispose();
    _topicFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BarrierContainer(
      showBarrier: _busy,
      child: BaseScaffold(
        appBar: AppBar(
          title: Text(l10n.matchingTitle),
          leading: IconButton(onPressed: _onBackPressed, icon: Icon(Icons.arrow_back)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameInfoWidget(gameInfo: gameInfo, playerId: uid),
            PlayerListWidget(gameState: gameState, playerId: uid),
            PlayerSettingWidget(
              initialValue: myInfo?.name ?? '',
              avatarFileName: myInfo?.avatarFileName ?? AppImages.avatar(0),
              onUpdated: _onPlayerNameUpdated,
              onTapAvatar: _onTapAvatar,
              focusNode: _playerFocusNode,
            ),
            if (isMaster)
              GameMasterWidget(
                initialValue: gameConfig.topic,
                onUpdated: _onTopicUpdated,
                onStartPressed: _isStartButtonEnabled ? _onStartPressed : null,
                focusNode: _topicFocusNode,
              ),
            if (!isMaster) GuestWidget(topic: gameConfig.topic),
          ],
        ),
      ),
    );
  }
}
