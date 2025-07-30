import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_online_cardgame/repository/firebase_repository.dart';

// import 'package:flutter_online_cardgame/repository/firebase_repository.dart';

class AppLifecycleHandlerWidget extends ConsumerStatefulWidget {
  final String gameId;
  final Widget child;
  const AppLifecycleHandlerWidget({super.key, required this.gameId, required this.child});

  @override
  ConsumerState<AppLifecycleHandlerWidget> createState() => _AppLifecycleHandlerState();
}

class _AppLifecycleHandlerState extends ConsumerState<AppLifecycleHandlerWidget>
    with WidgetsBindingObserver {
  HeartbeatNotifier? _heartbeatNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      _heartbeatNotifier = ref.read(heartbeatProvider(widget.gameId).notifier);
      _heartbeatNotifier?.start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future.microtask(() {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
        _heartbeatNotifier?.stop();
      } else if (state == AppLifecycleState.resumed) {
        _heartbeatNotifier?.start();
      }
    });
  }

  @override
  void dispose() {
    // ハートビートを確実に停止（StreamSubscriptionは即座にキャンセル）
    _heartbeatNotifier?.stop();
    _heartbeatNotifier = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class HeartbeatNotifier extends StateNotifier<bool> {
  final String gameId;
  HeartbeatNotifier({required this.gameId}) : super(false);

  final _interval = const Duration(seconds: 1);
  Duration get heartbeatInterval => const Duration(seconds: 10);
  late DateTime lastConnected = DateTime.now().add(heartbeatInterval);

  StreamSubscription? _sub;

  void start() {
    if (_sub != null) return;
    log('💚 HeartbeatNotifier start - gameId: $gameId', name: 'HeartbeatNotifier');
    state = true;
    _sub = Stream.periodic(_interval).listen((_) async {
      if (DateTime.now().difference(lastConnected) > heartbeatInterval) {
        try {
          if (!FirebaseRepository.shouldHeartbeat) return;
          FirebaseRepository.heartbeat(gameId: gameId);
          lastConnected = DateTime.now();
        } catch (e) {
          log('Error during heartbeat: $e', name: 'HeartbeatNotifier', error: e);
        }
      }
    });
  }

  void stop() {
    if (_sub != null) {
      log('❤️ HeartbeatNotifier stop - gameId: $gameId', name: 'HeartbeatNotifier');
    }
    _sub?.cancel();
    _sub = null;
    // 状態変更のみ遅延実行
    Future.microtask(() {
      state = false;
    });
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

StateNotifierProvider<HeartbeatNotifier, bool> heartbeatProvider(String gameId) =>
    StateNotifierProvider<HeartbeatNotifier, bool>((ref) => HeartbeatNotifier(gameId: gameId));
