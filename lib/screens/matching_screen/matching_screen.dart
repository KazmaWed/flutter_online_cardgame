import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/components/matching_tooltip_wrapper.dart';
import 'package:flutter_online_cardgame/constants/app_assets.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_config.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/repository/firebase_repository.dart';
import 'package:flutter_online_cardgame/screens/common/game_screen_mixin.dart';
import 'package:flutter_online_cardgame/screens/matching_screen/matching_screen_components.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/cookie_helper.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

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
  String _playerName = '';

  // Tooltip keys
  final _passwordShowcaseKey = GlobalKey(debugLabel: 'matching_password');
  final _playerAvaterShowcaseKey = GlobalKey(debugLabel: 'matching_player_avatar');
  final _playerNameShowcaseKey = GlobalKey(debugLabel: 'matching_player_name');
  final _topicShowcaseKey = GlobalKey(debugLabel: 'matching_topic');
  List<GlobalKey> _showcaseKeys = [];

  // Showcase control flags
  bool _shouldShowShowcase = false;

  @override
  GameInfo get gameInfo => widget.gameInfo;
  @override
  GameState get gameState => widget.gameState;
  @override
  GameConfig get gameConfig => gameState.config!;

  bool get _isStartButtonEnabled =>
      activePlayers.length >= 2 && isMaster && gameConfig.topic.isNotEmpty;

  void _onTapAvatar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AvatarSelectDialog(onAvatarSelected: _onAvatarSelected),
    );
  }

  void _onAvatarSelected(String avatarFileName) async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      final avatarIndex = avatarFileName.toAvatarIndex();
      await FirebaseRepository.updateAvatar(avatar: avatarIndex, gameId: gameInfo.gameId);

      // Show name tooltip if player name is not set
      if (_playerName.isEmpty) _resumeShowcase(_playerAvaterShowcaseKey);
    } catch (e) {
      handleApiError('update player avatar', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onPlayerNameUpdated(String name) async {
    if (_busy) return;
    _playerName = name;

    try {
      setState(() => _busy = true);
      await FirebaseRepository.updateName(name: name, gameId: gameInfo.gameId);

      // Show tooltip if topic is not set
      if (isMaster) _resumeShowcase(_playerNameShowcaseKey);
    } catch (e) {
      handleApiError('update player name', e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _onTopicUpdated(String topic) async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      await FirebaseRepository.updateTopic(gameId: gameInfo.gameId, topic: topic);

      // Show tooltip for start button
      if (isMaster) _resumeShowcase(_topicShowcaseKey);
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

  void _resumeShowcase(GlobalKey completedKey) {
    if (!_shouldShowShowcase) return;
    final index = _showcaseKeys.indexOf(completedKey);
    if (index == -1) return;

    // Update remaining keys and show next tooltip
    final remaining = _showcaseKeys.sublist(index + 1);
    setState(() {
      _showcaseKeys = remaining;
      _shouldShowShowcase = remaining.isNotEmpty;
    });
    ShowcaseView.get().startShowCase(remaining);

    // After the last showcase, mark showcase as shown
    if (remaining.length == 1) _markShowcaseAsShown();
  }

  void _dismissShowcase(GlobalKey key) => ShowcaseView.get().dismiss();

  void _markShowcaseAsShown() {
    if (isMaster) {
      CookieHelper.markShowcasedMatchingScreenAsMaster(uid);
    } else {
      CookieHelper.markShowcasedMatchingScreen(uid);
    }
    _shouldShowShowcase = false;
  }

  @override
  void initState() {
    final hasShown = isMaster
        ? CookieHelper.hasShowcasedMatchingScreenAsMaster(uid)
        : CookieHelper.hasShowcasedMatchingScreen(uid);
    _shouldShowShowcase = !hasShown;

    if (!_shouldShowShowcase) {
      _shouldShowShowcase = false;
      super.initState();
      return;
    }

    _showcaseKeys = [_playerAvaterShowcaseKey, _playerNameShowcaseKey];
    if (isMaster) _showcaseKeys = [_passwordShowcaseKey] + _showcaseKeys + [_topicShowcaseKey];

    super.initState();
  }

  @override
  void dispose() {
    _playerFocusNode.dispose();
    _topicFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseWrapper(
      showcaseKeys: _shouldShowShowcase ? _showcaseKeys : const [],
      child: Builder(
        builder: (context) {
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
                  GameInfoWidget(
                    gameInfo: gameInfo,
                    playerId: uid,
                    showcaseKey: isMaster ? _passwordShowcaseKey : null,
                    onShowcaseAdvance: isMaster ? (key) => _resumeShowcase(key) : null,
                  ),
                  PlayerListWidget(gameState: gameState, playerId: uid),
                  PlayerSettingWidget(
                    playerName: myInfo?.name ?? '',
                    avatarFileName: myInfo?.avatarFileName ?? AppAssets.avatar(0),
                    onUpdated: _onPlayerNameUpdated,
                    onTapAvatar: _onTapAvatar,
                    focusNode: _playerFocusNode,
                    avaterShowcaseKey: _playerAvaterShowcaseKey,
                    nameShowcaseKey: _playerNameShowcaseKey,
                    onShowcaseAdvance: (key) => _resumeShowcase(key),
                    onShowcaseDismiss: (key) => _dismissShowcase(key),
                  ),
                  if (isMaster)
                    GameMasterWidget(
                      topic: gameConfig.topic,
                      onUpdated: _onTopicUpdated,
                      onStartPressed: _isStartButtonEnabled ? _onStartPressed : null,
                      topicFocusNode: _topicFocusNode,
                      topicShowcaseKey: _topicShowcaseKey,
                      onShowcaseAdvance: (key) => _resumeShowcase(key),
                      onShowcaseDismiss: (key) => _dismissShowcase(key),
                    ),
                  if (!isMaster) GuestWidget(topic: gameConfig.topic),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
