import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

/// 中央寄せ・パディング・枠線付きの汎用コンテナ
class CenteredContainer extends StatelessWidget {
  final Widget child;

  const CenteredContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimentions.paddingSmall),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerHigh, width: 1),
        color: Theme.of(context).colorScheme.surfaceContainerLowest.withAlpha(128),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [child]),
    );
  }
}
