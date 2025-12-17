import 'package:flutter/widgets.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:flutter_online_cardgame/constants/app_constants.dart';

class AppShowcase extends StatelessWidget {
  const AppShowcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    this.title,
    this.description,
    this.onTargetClick,
    this.onToolTipClick,
    this.onBarrierClick,
    this.targetPadding = EdgeInsets.zero,
  });

  static const double _overlayOpacity = AppConstants.showcaseBarrierOpacity;
  static const bool _disposeOnTap = false;
  static const Duration _scaleAnimationDuration = Duration.zero;

  final GlobalKey showcaseKey;
  final Widget child;
  final String? title;
  final String? description;
  final EdgeInsets targetPadding;
  final VoidCallback? onTargetClick;
  final VoidCallback? onToolTipClick;
  final VoidCallback? onBarrierClick;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      overlayOpacity: _overlayOpacity,
      disposeOnTap: _disposeOnTap,
      scaleAnimationDuration: _scaleAnimationDuration,
      targetPadding: targetPadding,
      onTargetClick: onTargetClick,
      onToolTipClick: onToolTipClick,
      onBarrierClick: onBarrierClick,
      child: child,
    );
  }
}
