import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_online_cardgame/model/functions_responses/init_player_response.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/common/progress_screen.dart';
import 'package:flutter_online_cardgame/screens/common/error_screen.dart';
import 'package:flutter_online_cardgame/screens/game_screen/game_initialize_screen.dart';
import 'package:flutter_online_cardgame/screens/join_game_screen.dart';
import 'package:flutter_online_cardgame/screens/top_screen.dart';
import 'package:flutter_online_cardgame/services/image_preloader_service.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  Future<InitPlayerResponse> _initPlayer() async {
    return FunctionsRepository.initPlayer();
  }

  void _navigateToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        FadePageRoute(builder: (context) => const TopScreen()),
        (route) => false,
      );
    });
  }

  void _navigateToGame(String gameId) async {
    try {
      final response = await FunctionsRepository.getGameInfo(gameId: gameId);
      await FunctionsRepository.enterGame(password: response.password);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          FadePageRoute(builder: (context) => GameInitializeScreen(gameInfo: response.toGameInfo)),
          (route) => false,
        );
      });
    } catch (e) {
      // TODO: Handle error appropriately
      debugPrint('Error navigating to game: $e');
    }
  }

  void _navigateToJoinGame(String? pin) async {
    await FirebaseAuth.instance.signInAnonymously();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        FadePageRoute(builder: (context) => JoinGameScreen(pin: pin)),
        (route) => false,
      );
    });
  }

  final pin = Uri.base.queryParameters['pin'];

  @override
  Widget build(BuildContext context) {
    ImagePreloaderService.preloadAllImages(context);

    // When entered with invitation link
    if (pin != null) {
      _navigateToJoinGame(pin);
      return const ProgressScreen();
    }

    // When auth account is not logged in
    if (!FunctionsRepository.isLoggedIn) {
      _navigateToTop();
    }

    // Check if player is already in a game
    return Scaffold(
      body: FutureBuilder(
        future: _initPlayer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProgressScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(message: snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const ErrorScreen(message: "No data obtained from server");
          }

          final data = snapshot.data!;

          if (data.gameId != null) {
            _navigateToGame(data.gameId!);
          } else {
            _navigateToTop();
          }

          return const ProgressScreen();
        },
      ),
    );
  }
}
