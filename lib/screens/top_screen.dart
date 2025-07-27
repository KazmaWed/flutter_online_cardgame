import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/game_screen/game_initialize_screen.dart';
import 'package:flutter_online_cardgame/screens/instruction_screen/instruction_screen.dart';
import 'package:flutter_online_cardgame/screens/join_game_screen.dart';
import 'package:flutter_online_cardgame/screens/top_screen_components.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoggedIn = FunctionsRepository.isLoggedIn;
  bool _busy = false;

  void _createGame() async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      final gameInfo = await FunctionsRepository.createGame();
      if (!mounted) return;
      Navigator.of(
        context,
      ).push(FadePageRoute(builder: (context) => GameInitializeScreen(gameInfo: gameInfo)));
    } catch (e) {
      debugPrint('Error creating game: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  void _joinGame() {
    Navigator.of(context).push(FadePageRoute(builder: (context) => JoinGameScreen()));
  }

  void _instruction() {
    Navigator.of(context).push(FadePageRoute(builder: (context) => InstructionScreen()));
  }

  void _signin() async {
    if (_busy) return;
    try {
      setState(() => _busy = true);
      await Future.wait([
        FirebaseAuth.instance.signInAnonymously(),
        Future.delayed(AppConstants.authSigninDelay),
      ]);
    } catch (e) {
      // TODO: Handle error appropriately
      debugPrint('Error signing in: $e');
    } finally {
      setState(() {
        _isLoggedIn = FunctionsRepository.isLoggedIn;
        _busy = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final linkTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue);

    final linkButtonStyle = TextButton.styleFrom(
      overlayColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimentions.paddingSmall),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimentions.paddingLarge, vertical: 8.0),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
    );

    final githubButton = TextButton(
      onPressed: () async {
        final uri = Uri.parse('https://github.com/KazmaWed/flutter_online_cardgame');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      style: linkButtonStyle,
      child: Text('Github', style: linkTextStyle),
    );

    final licenseButton = TextButton(
      onPressed: () => showLicensePage(context: context),
      style: linkButtonStyle,
      child: Text('ライセンス', style: linkTextStyle),
    );

    return BarrierContainer(
      showBarrier: _busy,
      child: BaseScaffold(
        bottomNavigationBar: Row(children: [licenseButton, Spacer(), githubButton]),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: SizedBox(
            width: AppDimentions.screenWidth * 0.8,
            child: Column(
              spacing: AppDimentions.paddingLarge,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GameTitleWidget(title: l10n.appTitle),
                SizedBox(
                  width: AppDimentions.screenWidthExtraThin,
                  child: _isLoggedIn
                      ? GameMenuWidget(
                          onCreateGame: _createGame,
                          onJoinGame: _joinGame,
                          onHowToPlay: _instruction,
                        )
                      : Center(
                          child: RectangularTextButton(label: 'はじめる', onPressed: _signin),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
