import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';

extension NavigatorExtension on NavigatorState {
  Future<void> popAndRemove(FadePageRoute page) {
    return Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            page.pageBuilder(context, animation, secondaryAnimation),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false, // 全てのルートを削除
    );
  }

  void popToTop() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TopScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false, // 全てのルートを削除
    );
  }
}
