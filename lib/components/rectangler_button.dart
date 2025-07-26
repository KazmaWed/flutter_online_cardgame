import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

class RectangularBaseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;

  const RectangularBaseButton({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimentions.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          disabledBackgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          shadowColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class RectangularRowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const RectangularRowButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RectangularBaseButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: onPressed != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(128),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RectangularTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const RectangularTextButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: AppDimentions.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onPressed != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurface.withAlpha(128),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
