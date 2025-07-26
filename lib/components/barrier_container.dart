import 'package:flutter/material.dart';

class BarrierContainer extends StatelessWidget {
  final Widget child;
  final bool showBarrier;
  const BarrierContainer({super.key, required this.showBarrier, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Center(child: child),
        AnimatedOpacity(
          opacity: showBarrier ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !showBarrier,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Container(color: Colors.black.withAlpha(128)),
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
