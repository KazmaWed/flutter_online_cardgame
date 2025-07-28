import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({super.key, this.body, this.appBar, this.bottomNavigationBar});

  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBarHeight = appBar?.preferredSize.height ?? 0;
    final bottomNavHeight = bottomNavigationBar != null ? kBottomNavigationBarHeight : 0;
    final availableHeight =
        mediaQuery.size.height -
        appBarHeight -
        bottomNavHeight -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    return Scaffold(
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: appBar!.preferredSize,
              child: Center(
                child: SizedBox(width: AppDimentions.screenWidth, child: appBar),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: AppDimentions.screenWidth,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: availableHeight),
                          child: IntrinsicHeight(
                            child: body != null
                                ? Center(
                                    child: Container(alignment: Alignment.center, child: body),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: bottomNavHeight.toDouble(),
              padding: const EdgeInsets.symmetric(horizontal: AppDimentions.paddingLarge),
              child: bottomNavigationBar ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
