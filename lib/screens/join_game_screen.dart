import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:web/web.dart' as web;

import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/repository/firebase_repository.dart';
import 'package:flutter_online_cardgame/screens/game_screen/game_initialize_screen.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';
import 'package:flutter_online_cardgame/util/fade_page_route.dart';
import 'package:flutter_online_cardgame/util/full_width_digit_formatter.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key, this.pin});
  final String? pin;

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  late final TextEditingController _pinController;
  late final FocusNode _focusNode;

  bool _isLoggedIn = FirebaseRepository.isLoggedIn;
  bool _busy = false;

  bool get isValidPin =>
      _pinController.text.length == 4 && int.tryParse(_pinController.text) != null;

  void _signin() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_busy) return;
      try {
        setState(() => _busy = true);
        await Future.wait([
          Future.delayed(AppConstants.authSigninDelay),
          FirebaseAuth.instance.signInAnonymously(),
        ]);
      } catch (e) {
        // TODO: Handle error appropriately
        debugPrint('Error signing in: $e');
      } finally {
        setState(() {
          _isLoggedIn = FirebaseRepository.isLoggedIn;
          _busy = false;
        });
      }
    });
  }

  Future<void> _onPressed() async {
    try {
      if (!isValidPin || _busy) return;
      setState(() => _busy = true);

      final pin = _pinController.text;
      final enterGameResponce = await FirebaseRepository.enterGame(password: pin);
      final gameInfo = GameInfo(
        gameId: enterGameResponce.gameId,
        password: enterGameResponce.password,
      );

      if (!mounted) return;
      Navigator.of(
        context,
      ).push(FadePageRoute(builder: (context) => GameInitializeScreen(gameInfo: gameInfo)));
    } catch (e) {
      // TODO: Handle error appropriately
      debugPrint('Error joining game: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  void _resetUrl() {
    final current = Uri.base.toString();
    final updated = current.removePin();
    if (current == updated) return;
    web.window.history.replaceState(null, '', updated);
  }

  @override
  void initState() {
    _pinController = TextEditingController(text: widget.pin ?? '');
    _focusNode = FocusNode();

    if (!_isLoggedIn) _signin();
    _resetUrl();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget child = BarrierContainer(
      showBarrier: _busy || !_isLoggedIn,
      child: BaseScaffold(
        appBar: AppBar(
          title: Text(l10n.joinGameTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).popToTop(),
          ),
        ),
        body: !_isLoggedIn
            ? SizedBox.shrink()
            : Card(
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(AppDimentions.paddingLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16.9,
                    children: [
                      Text(l10n.enterCodeInstruction),
                      SizedBox(
                        width: 200,
                        child: Pinput(
                          length: 4,
                          controller: _pinController,
                          focusNode: _focusNode,
                          autofocus: !kIsWeb,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() => _pinController.text = value);
                          },
                          onSubmitted: (value) {
                            if (isValidPin) _onPressed();
                          },
                          inputFormatters: [
                            FullWidthDigitFormatter(),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          defaultPinTheme: PinTheme(
                            width: 40,
                            height: 50,
                            textStyle: const TextStyle(fontSize: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.surfaceContainerLowest,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: RectangularRowButton(
                          onPressed: isValidPin ? _onPressed : null,
                          label: l10n.join,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );

    return child;
  }
}
