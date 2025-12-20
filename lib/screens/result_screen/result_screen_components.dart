import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/components/avatar_container.dart';
import 'package:flutter_online_cardgame/components/row_card.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/constants/app_fonts.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_result.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

class ScoreWidget extends StatefulWidget {
  final GameResult result;

  const ScoreWidget({super.key, required this.result});

  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AppConstants.scoreAnimationDuration,
      vsync: this,
    );

    // Normalize score to 0-1 range for CircularProgressIndicator
    final normalizedScore = widget.result.playerResults.isNotEmpty
        ? widget.result.score / widget.result.playerResults.length
        : 0.0;

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: normalizedScore,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.result.score,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final topicStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontFamily: AppFonts.notoSansJP,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    final scoreLargeStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    final scoreSmallStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );

    return RowCard(
      children: [
        Text(l10n.results, style: headerStyle),
        Text(widget.result.topic, style: topicStyle),
        Padding(
          padding: const EdgeInsets.all(AppDimentions.paddingMedium),
          child: SizedBox(
            width: AppDimentions.resultCircleSize,
            height: AppDimentions.resultCircleSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (widget.result.playerResults.isNotEmpty)
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _progressAnimation.value,
                        color: Theme.of(context).colorScheme.primary,
                        constraints: BoxConstraints.expand(),
                        strokeWidth: AppDimentions.paddingMedium,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                      );
                    },
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.correctAnswers),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: AppDimentions.paddingMicro,
                      children: [
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return Text(_scoreAnimation.value.toString(), style: scoreLargeStyle);
                          },
                        ),
                        Text(l10n.scoreSeparator, style: scoreSmallStyle),
                        Text(widget.result.playerResults.length.toString(), style: scoreSmallStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Text(widget.result.perfectGame ? l10n.perfectGameMessage : l10n.goodGameMessage),
      ],
    );
  }
}

class PlayerResultsWidget extends StatefulWidget {
  final GameResult result;

  const PlayerResultsWidget({super.key, required this.result});

  @override
  State<PlayerResultsWidget> createState() => _PlayerResultsWidgetState();
}

class _PlayerResultsWidgetState extends State<PlayerResultsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AppConstants.scoreAnimationDuration,
      vsync: this,
    );

    // Create staggered animations for each card
    final cardCount = widget.result.playerResults.length;
    _cardAnimations = List.generate(cardCount, (index) {
      final startTime = (index / cardCount) * 0.8; // Start animations in first 80% of duration
      final endTime = startTime + 0.3; // Each card animation takes 30% of total duration

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(startTime, endTime.clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      );
    });

    // Start animation after a delay to sync with score animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

    return RowCard(
      children: [
        Text(l10n.correctAnswersAnnouncement, style: headerStyle),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withAlpha(128),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.all(AppDimentions.paddingMedium),
          child: Column(
            children: [
              PlayerResultHeader(),
              Divider(height: 1),
              ...widget.result.playerResults.asMap().entries.expand((entry) {
                final index = entry.key;
                final player = entry.value;

                return [
                  AnimatedBuilder(
                    animation: _cardAnimations[index],
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _cardAnimations[index],
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.2),
                            end: Offset.zero,
                          ).animate(_cardAnimations[index]),
                          child: PlayerResultCard(player: player),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1),
                ];
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerResultCard extends StatelessWidget {
  final PlayerResult player;

  const PlayerResultCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = Theme.of(context).textTheme.bodyLarge!;
    final nameColumnWidth =
        Theme.of(context).textTheme.bodyLarge!.fontSize! * AppConstants.maxPlayerNameLength +
        AppDimentions.paddingSmall * 2 +
        AppDimentions.avatarSizeXS;

    final largeStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final indexStyle = largeStyle?.copyWith(
      color: player.isCorrect
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface,
      fontWeight: player.isCorrect ? FontWeight.bold : FontWeight.normal,
    );

    final icon = player.isCorrect
        ? Icon(
            Icons.thumb_up_alt_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: AppDimentions.resultColumnIcon - AppDimentions.paddingSmall * 2,
          )
        : null;

    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(AppDimentions.paddingSmall),
        child: Builder(
          builder: (context) {
            // MediaQueryを使用して画面幅を取得
            final screenWidth = MediaQuery.of(context).size.width;
            final isNarrow = screenWidth < AppDimentions.screenWidthNarrow;

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1行目: 名前、値、順位、アイコン
                  Row(
                    spacing: AppDimentions.paddingSmall,
                    children: [
                      AvatarContainer(
                        size: AppDimentions.avatarSizeXS,
                        fileName: player.avatarFileName,
                      ),
                      Text(player.name.toNameString(), style: style),
                    ],
                  ),
                  // 2行目: ヒント
                  Row(
                    spacing: AppDimentions.paddingSmall,
                    children: [
                      Expanded(child: Text(player.hint.toHintString(), style: style)),
                      Container(
                        alignment: Alignment.center,
                        width: AppDimentions.resultColumnValue,
                        child: Text(player.value.toString(), style: largeStyle),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: AppDimentions.resultColumnOrder,
                        child: Text(l10n.submitOrderText(player.submitted), style: indexStyle),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: AppDimentions.resultColumnOrder,
                        child: Text(l10n.submitOrderText(player.index), style: indexStyle),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: AppDimentions.resultColumnIcon,
                        child: icon,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // 通常レイアウト: 1行
              return Row(
                mainAxisSize: MainAxisSize.max,
                spacing: AppDimentions.paddingSmall,
                children: [
                  SizedBox(
                    width: nameColumnWidth,
                    child: Row(
                      spacing: AppDimentions.paddingSmall,
                      children: [
                        AvatarContainer(
                          size: AppDimentions.avatarSizeXS,
                          fileName: player.avatarFileName,
                        ),
                        Text(player.name.toNameString(), style: style),
                      ],
                    ),
                  ),
                  Expanded(flex: 3, child: Text(player.hint.toHintString(), style: style)),
                  Container(
                    alignment: Alignment.center,
                    width: AppDimentions.resultColumnValue,
                    child: Text(player.value.toString(), style: largeStyle),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: AppDimentions.resultColumnOrder,
                    child: Text(l10n.submitOrderText(player.submitted), style: indexStyle),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: AppDimentions.resultColumnOrder,
                    child: Text(l10n.submitOrderText(player.index), style: indexStyle),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: AppDimentions.resultColumnIcon,
                    child: icon,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PlayerResultHeader extends StatelessWidget {
  const PlayerResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    final nameColumnWidth =
        Theme.of(context).textTheme.bodyLarge!.fontSize! * AppConstants.maxPlayerNameLength +
        AppDimentions.paddingSmall * 2 +
        AppDimentions.avatarSizeXS;

    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < AppDimentions.screenWidthNarrow;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimentions.paddingSmall,
        vertical: AppDimentions.paddingSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: AppDimentions.paddingSmall,
        children: [
          if (!isNarrow)
            SizedBox(
              width: nameColumnWidth,
              child: Text(l10n.playerHeader, style: style),
            ),
          Expanded(flex: 3, child: Text(l10n.hintHeader, style: style)),
          Container(
            alignment: Alignment.center,
            width: AppDimentions.resultColumnValue,
            child: Text(l10n.numberHeader, style: style),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: AppDimentions.resultColumnOrder,
            child: Text(l10n.guessHeader, style: style),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: AppDimentions.resultColumnOrder,
            child: Text(l10n.correctHeader, style: style),
          ),
          SizedBox(width: AppDimentions.resultColumnIcon),
        ],
      ),
    );
  }
}
