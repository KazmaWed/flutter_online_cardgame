import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/components/animation_wrap.dart';
import 'package:flutter_online_cardgame/components/avatar_container.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/components/row_card.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/constants/app_fonts.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/player_info.dart';
import 'package:flutter_online_cardgame/model/player_state.dart';
import 'package:flutter_online_cardgame/util/multi_byte_length_formatter.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

class TopicCardWidget extends StatelessWidget {
  final String topic;
  const TopicCardWidget({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final topicStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontFamily: AppFonts.modhyPopPOne,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );

    return RowCard(
      children: [
        Text(l10n.topic, style: headerStyle),
        Text(topic, style: topicStyle),
      ],
    );
  }
}

class PlayerInfoWidget extends StatefulWidget {
  final Map<String, PlayerInfo> playerInfoMap;
  final List<PlayerState> submittedPlayers;
  final List<PlayerState> pendingPlayers;
  final PlayerInfo me;
  const PlayerInfoWidget({
    super.key,
    required this.playerInfoMap,
    required this.submittedPlayers,
    required this.pendingPlayers,
    required this.me,
  });

  @override
  State<PlayerInfoWidget> createState() => _PlayerInfoWidgetState();
}

class _PlayerInfoWidgetState extends State<PlayerInfoWidget> {
  Set<String> _prevSubmittedPlayerIds = {};
  Set<String> _prevPendingPlayerIds = {};
  String? _movingPlayerId;

  @override
  void didUpdateWidget(covariant PlayerInfoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentSubmittedIds = widget.submittedPlayers.map((p) => p.id).toSet();
    final currentPendingIds = widget.pendingPlayers.map((p) => p.id).toSet();

    // submittedからpendingに移動したプレイヤーを検出
    final movedToPending = _prevSubmittedPlayerIds.intersection(currentPendingIds);
    // pendingからsubmittedに移動したプレイヤーを検出
    final movedToSubmitted = _prevPendingPlayerIds.intersection(currentSubmittedIds);

    if (movedToPending.isNotEmpty) {
      _movingPlayerId = movedToPending.first;
    } else if (movedToSubmitted.isNotEmpty) {
      _movingPlayerId = movedToSubmitted.first;
    } else {
      _movingPlayerId = null;
    }

    // 次回比較用に現在の状態を保存
    _prevSubmittedPlayerIds = currentSubmittedIds;
    _prevPendingPlayerIds = currentPendingIds;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return RowCard(
      children: [
        Text(l10n.everyonesAnswers, style: headerStyle),
        Text(
          l10n.submissionStatus(
            widget.submittedPlayers.length,
            [...widget.submittedPlayers, ...widget.pendingPlayers].length,
          ),
          style: textStyle,
        ),
        Column(
          spacing: AppDimentions.paddingSmall,
          children: [
            AnimationWrap(
              movingChildKey: _movingPlayerId != null ? ValueKey(_movingPlayerId!) : null,
              children: [
                if (widget.submittedPlayers.isNotEmpty)
                  ...widget.submittedPlayers.map(
                    (player) => PlayerHintCard(
                      playerState: player,
                      playerInfo: widget.playerInfoMap[player.id]!,
                      index: widget.submittedPlayers.indexOf(player) + 1,
                      isMe: player.id == widget.me.id,
                      key: ValueKey(player.id),
                    ),
                  ),
                if (widget.pendingPlayers.isNotEmpty)
                  ...widget.pendingPlayers.map(
                    (player) => PlayerHintCard(
                      playerState: player,
                      playerInfo: widget.playerInfoMap[player.id]!,
                      isMe: player.id == widget.me.id,
                      key: ValueKey(player.id),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SubmitWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final PlayerInfo me;
  final int value;
  final String topic;
  final int? submittedOrder;
  final String instruction;
  final String buttonText;
  final bool submitEnabled;
  final bool withdrawEnabled;
  final VoidCallback onSubmit;
  final VoidCallback onWithdraw;
  final VoidCallback onClear;

  const SubmitWidget({
    super.key,
    required this.me,
    required this.value,
    required this.topic,
    required this.submittedOrder,
    required this.buttonText,
    required this.instruction,
    required this.submitEnabled,
    required this.withdrawEnabled,
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
    required this.onWithdraw,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final baseStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final boldStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontFamily: AppFonts.modhyPopPOne,
      color: Theme.of(context).colorScheme.primary,
    );
    final descriptionStyle = Theme.of(context).textTheme.bodyLarge;

    return RowCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppDimentions.paddingMicro,
            children: [
              Text(l10n.yourNumberIs, style: baseStyle),
              Text(value.toString(), style: boldStyle),
              Text(l10n.desu, style: baseStyle),
            ],
          ),
        ),
        Text(instruction, style: descriptionStyle),
        TextField(
          maxLength: AppConstants.maxPlayerHintLength,
          controller: controller,
          readOnly: submittedOrder != null,
          focusNode: focusNode,
          enabled: submittedOrder == null,
          inputFormatters: [MultiByteLengthFormatter(AppConstants.maxPlayerHintLength)],
          buildCounter: MultiByteLengthFormatter.createCounterBuilder(controller, AppConstants.maxPlayerHintLength),
          decoration: InputDecoration(
            labelText: l10n.hint,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
            suffixIcon: (submittedOrder == null && controller.text.isNotEmpty)
                ? IconButton(
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () {
                      controller.clear();
                      onClear();
                    },
                  )
                : null,
          ),
        ),
        Row(
          spacing: AppDimentions.paddingSmall,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: RectangularRowButton(
                onPressed: submitEnabled ? onSubmit : null,
                label: buttonText,
              ),
            ),
            SizedBox(
              width: AppDimentions.buttonWidth,
              child: withdrawEnabled
                  ? RectangularRowButton(
                      onPressed: withdrawEnabled ? onWithdraw : null,
                      label: l10n.cancel,
                    )
                  : RectangularTextButton(onPressed: null, label: l10n.cancel),
            ),
          ],
        ),
      ],
    );
  }
}

class PlayerHintCard extends StatelessWidget {
  final PlayerInfo playerInfo;
  final PlayerState playerState;
  final int? index;
  final bool isMe;
  const PlayerHintCard({
    super.key,
    required this.playerInfo,
    required this.playerState,
    required this.isMe,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pad = AppDimentions.paddingMicro;
    final width = 166.0;
    final radius = pad + AppDimentions.avatarSizeS / 2;

    final indexText = index == null ? l10n.notSubmitted : l10n.submitOrderText(index!);

    final nameStyle = Theme.of(context).textTheme.bodyMedium;
    final meStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );
    final indexStyle = nameStyle?.copyWith(
      fontWeight: index == null ? FontWeight.normal : FontWeight.bold,
      color: index == null
          ? Theme.of(context).colorScheme.onSurface.withAlpha(168)
          : Theme.of(context).colorScheme.primary,
    );
    final baseStyle = Theme.of(context).textTheme.bodyLarge!;
    final hintStyle = playerState.hint.isEmpty
        ? baseStyle.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(128))
        : baseStyle.copyWith(fontWeight: FontWeight.bold);

    final cardColor = playerState.submitted == null
        ? Theme.of(context).colorScheme.surfaceContainer
        : Theme.of(context).colorScheme.surfaceContainerLowest;

    return Column(
      spacing: AppDimentions.paddingMicro,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: pad * 2, vertical: pad / 2),
          decoration: BoxDecoration(
            color: index == null ? null : Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: SelectableText(indexText, style: indexStyle),
        ),
        Container(
          width: width,
          padding: EdgeInsets.all(pad),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
          ),
          child: Column(
            spacing: AppDimentions.paddingMicro,
            children: [
              Row(
                spacing: AppDimentions.paddingMicro,
                children: [
                  AvatarContainer(
                    size: AppDimentions.avatarSizeS,
                    fileName: playerInfo.avatarFileName,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMe) Text(l10n.you, style: meStyle),
                      SelectableText(playerInfo.name.toNameString(), style: nameStyle),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimentions.paddingMicro),
                child: Divider(height: 1),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(AppDimentions.paddingMicro),
                height:
                    hintStyle.fontSize! * hintStyle.height! * 2 + AppDimentions.paddingMicro * 2,
                child: SelectableText(
                  playerState.hint.toHintString(),
                  style: hintStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GameMasterWidget extends StatelessWidget {
  final bool gameOverEnabled;
  final VoidCallback? onEndGame;
  final VoidCallback? onTapGameMasterMenu;

  const GameMasterWidget({
    super.key,
    required this.gameOverEnabled,
    this.onEndGame,
    this.onTapGameMasterMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimentions.paddingMedium + AppDimentions.paddingMicro,
      ),
      child: Row(
        spacing: AppDimentions.paddingSmall,
        children: [
          Expanded(
            child: Opacity(
              opacity: gameOverEnabled ? 1.0 : 0.0,
              child: RectangularBaseButton(
                onPressed: gameOverEnabled ? onEndGame : null,
                child: Text(l10n.viewResults),
              ),
            ),
          ),
          SizedBox(
            width: AppDimentions.buttonWidth,
            child: RectangularTextButton(onPressed: onTapGameMasterMenu, label: AppLocalizations.of(context)!.kick),
          ),
        ],
      ),
    );
  }
}
