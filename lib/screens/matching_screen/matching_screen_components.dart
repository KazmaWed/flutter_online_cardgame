import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:web/web.dart' as web;

import 'package:flutter_online_cardgame/components/avatar_container.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/components/row_card.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/model/game_state.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/topic_data.dart';
import 'package:flutter_online_cardgame/screens/common/error_screen.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

class GameInfoWidget extends StatelessWidget {
  final GameInfo gameInfo;
  final String playerId;
  const GameInfoWidget({super.key, required this.gameInfo, required this.playerId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pinController = TextEditingController(text: gameInfo.password);

    return RowCard(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppDimentions.paddingSmall,
          children: [
            Text(
              l10n.password,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(l10n.sharePasswordInstruction),
            Container(
              width: 210,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppDimentions.paddingSmall,
                      children: [
                        Pinput(
                          controller: pinController,
                          length: 4,
                          enabled: false,
                          defaultPinTheme: PinTheme(
                            width: 40,
                            height: 50,
                            textStyle: const TextStyle(fontSize: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            ),
                          ),
                        ),

                        Text(
                          l10n.tapToCopyInviteUrl,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      final url = web.window.location.href.withPin(pinController.text);
                      await Clipboard.setData(ClipboardData(text: url));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l10n.urlCopiedMessage)));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PlayerListWidget extends StatelessWidget {
  final GameState gameState;
  final String playerId;
  const PlayerListWidget({super.key, required this.gameState, required this.playerId});

  @override
  Widget build(BuildContext context) {
    if (gameState.config == null) {
      return ErrorScreen(message: AppLocalizations.of(context)!.gameWatchFailed);
    }

    return RowCard(
      children: [
        Column(
          spacing: AppDimentions.paddingMedium,
          children: [
            Text(
              '参加者',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: AppDimentions.paddingSmall,
              runSpacing: AppDimentions.paddingSmall,
              children: [
                for (var playerInfo in gameState.activePlayersInfo)
                  PlayerCard(playerInfo: playerInfo, isMyself: playerInfo.id == playerId),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class PlayerCard extends StatelessWidget {
  final PlayerInfo playerInfo;
  final bool isMyself;
  const PlayerCard({super.key, required this.playerInfo, required this.isMyself});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pad = AppDimentions.paddingMicro;
    final width = 166.0;
    final height = pad * 2 + AppDimentions.avatarSizeS;

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: pad),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
      ),
      child: Row(
        spacing: AppDimentions.paddingMicro,
        children: [
          // Cont
          AvatarContainer(size: AppDimentions.avatarSizeS, fileName: playerInfo.avatarFileName),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMyself)
                Text(
                  l10n.you,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SelectableText(
                playerInfo.name.toNameString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerSettingWidget extends StatefulWidget {
  const PlayerSettingWidget({
    super.key,
    required this.playerName,
    required this.avatarFileName,
    required this.onUpdated,
    required this.onTapAvatar,
    required this.focusNode,
  });

  final String playerName;
  final String avatarFileName;
  final Function(String) onUpdated;
  final VoidCallback onTapAvatar;
  final FocusNode focusNode;

  @override
  State<PlayerSettingWidget> createState() => _PlayerSettingWidgetState();
}

class _PlayerSettingWidgetState extends State<PlayerSettingWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.playerName;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(PlayerSettingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // プレイヤー名が変更された時のみテキストを更新（入力中でない場合）
    if (oldWidget.playerName != widget.playerName && !widget.focusNode.hasFocus) {
      _textController.text = widget.playerName;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) {
      widget.onUpdated(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RowCard(
      children: [
        Text(
          'プレイヤー設定',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: AppDimentions.paddingLarge,
          children: [
            Column(
              spacing: AppDimentions.paddingSmall,
              children: [
                Text(l10n.avatar),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimentions.paddingSmall),
                  child: AvatarButtonContainer(
                    size: AppDimentions.avatarSizeL,
                    fileName: widget.avatarFileName,
                    onTap: widget.onTapAvatar,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                spacing: 30,
                children: [
                  Text(l10n.enterPlayerNameInstruction),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          maxLength: AppConstants.maxPlayerNameLength,
                          controller: _textController,
                          focusNode: widget.focusNode,
                          decoration: InputDecoration(
                            labelText: l10n.playerNameLabel,
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                setState(() => _textController.clear());
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AvatarSelectDialog extends StatelessWidget {
  final void Function(String avatarFileName) onAvatarSelected;
  const AvatarSelectDialog({super.key, required this.onAvatarSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatarList = List.generate(
      12,
      (i) => 'assets/images/avatar${i.toString().padLeft(2, '0')}.jpg',
    );
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(AppDimentions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.selectAvatar, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: 480,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: avatarList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppDimentions.paddingSmall,
                  crossAxisSpacing: AppDimentions.paddingSmall,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final fileName = avatarList[index];
                  return OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onAvatarSelected(fileName);
                    },
                    clipBehavior: Clip.antiAlias,
                    style: OutlinedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Image.asset(fileName, fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameMasterWidget extends StatefulWidget {
  const GameMasterWidget({
    super.key,
    required this.topic,
    required this.onUpdated,
    required this.onStartPressed,
    required this.focusNode,
  });
  final String topic;
  final Function(String) onUpdated;
  final VoidCallback? onStartPressed;
  final FocusNode focusNode;

  @override
  State<GameMasterWidget> createState() => _GameMasterWidgetState();
}

class _GameMasterWidgetState extends State<GameMasterWidget> {
  final TextEditingController _textController = TextEditingController();

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) {
      widget.onUpdated(_textController.text);
    }
  }

  void _onClear() {
    setState(() => _textController.clear());
    widget.onUpdated('');
  }

  void _onTapRecommendation() async {
    final selectedTopic = await showDialog<String>(
      context: context,
      builder: (context) => const TopicRecommendationDialog(),
    );

    if (selectedTopic != null) {
      _textController.text = selectedTopic;
      widget.onUpdated(selectedTopic);
    }
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.topic;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(GameMasterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic != widget.topic && !widget.focusNode.hasFocus) {
      _textController.text = widget.topic;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RowCard(
      children: [
        Text(
          'ゲーム設定',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(l10n.setTopicInstruction),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppDimentions.paddingSmall,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: widget.focusNode,
                maxLength: AppConstants.maxTopicLength,
                decoration: InputDecoration(
                  labelText: l10n.topicLabel,
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.clear_rounded), onPressed: _onClear),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: RectangularTextButton(label: 'おすすめ\nから選ぶ', onPressed: _onTapRecommendation),
            ),
          ],
        ),
        RectangularRowButton(onPressed: widget.onStartPressed, label: l10n.startGame),
      ],
    );
  }
}

class TopicRecommendationDialog extends StatefulWidget {
  const TopicRecommendationDialog({super.key});

  @override
  State<TopicRecommendationDialog> createState() => _TopicRecommendationDialogState();
}

class _TopicRecommendationDialogState extends State<TopicRecommendationDialog> {
  TopicData? _topicData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/topics.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _topicData = TopicData.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimentions.paddingLarge),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(AppDimentions.paddingLarge),
          child: Column(
            children: [
              Text(
                'おすすめトピック',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _topicData == null
                    ? Center(child: Text(AppLocalizations.of(context)!.dataLoadFailed))
                    : ListView(children: _buildTopicList()),
              ),
              const SizedBox(height: AppDimentions.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.cancelButton),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTopicList() {
    if (_topicData == null) return [];

    final List<Widget> widgets = [];

    for (final category in _topicData!.categoryNames) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimentions.paddingSmall,
            top: AppDimentions.paddingLarge,
            bottom: AppDimentions.paddingSmall,
          ),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
      final topics = _topicData!.getTopicsForCategory(category);
      for (final topic in topics) {
        widgets.add(
          ListTile(
            title: Text(topic),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimentions.paddingSmall,
              vertical: 0,
            ),
            onTap: () {
              Navigator.of(context).pop(topic);
            },
          ),
        );
      }
    }

    return widgets;
  }
}

class GuestWidget extends StatelessWidget {
  final String topic;
  const GuestWidget({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final style = topic.isNotEmpty
        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
        : Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary);
    final topicFixed = topic.isNotEmpty ? topic : '未設定';
    return RowCard(
      children: [
        Text(
          'ゲーム設定',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(topicFixed, style: style),
      ],
    );
  }
}
