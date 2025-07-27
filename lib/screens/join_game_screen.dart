import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_online_cardgame/components/barrier_container.dart';
import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/components/rectangler_button.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
import 'package:flutter_online_cardgame/repository/functions_repository.dart';
import 'package:flutter_online_cardgame/screens/game_screen/game_initialize_screen.dart';
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
  FocusNode? _keyboardFocusNode;

  bool _isLoggedIn = FunctionsRepository.isLoggedIn;
  bool _busy = false;
  web.EventListener? _keydownListener;

  bool get isValidPin =>
      _pinController.text.length == 4 && int.tryParse(_pinController.text) != null;

  void _signin() async {
    print('_isLoggedIn: $_isLoggedIn, _busy: $_busy');
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
          _isLoggedIn = FunctionsRepository.isLoggedIn;
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
      final enterGameResponce = await FunctionsRepository.enterGame(password: pin);
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

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent && _isLoggedIn && !_busy) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.backspace && _pinController.text.isNotEmpty) {
        setState(() {
          _pinController.text = _pinController.text.substring(0, _pinController.text.length - 1);
        });
        return true;
      } else if (key == LogicalKeyboardKey.enter && isValidPin) {
        _onPressed();
        return true;
      }
    }
    return false;
  }

  void _resetUrl() {
    final uri = Uri.base;
    if (uri.queryParameters.isNotEmpty) {
      final newUri = uri
          .replace(queryParameters: {})
          .toString()
          .substring(0, uri.toString().lastIndexOf('?'));
      web.window.history.replaceState(null, '', newUri.toString());
    }
  }

  void _handleWebKeyboardEvent(String key) {
    if (_isLoggedIn && !_busy && mounted) {
      if (key == 'Backspace' && _pinController.text.isNotEmpty) {
        setState(() {
          _pinController.text = _pinController.text.substring(0, _pinController.text.length - 1);
        });
      } else if (key == 'Enter' && isValidPin) {
        _onPressed();
      } else if (RegExp(r'^[0-9]$').hasMatch(key) && _pinController.text.length < 4) {
        setState(() {
          _pinController.text += key;
        });
      }
    }
  }

  void _setupGlobalKeyListener() {
    _keydownListener = ((web.Event event) {
      final keyEvent = event as web.KeyboardEvent;
      _handleWebKeyboardEvent(keyEvent.key);
      if (keyEvent.key == 'Backspace' ||
          keyEvent.key == 'Enter' ||
          RegExp(r'^[0-9]$').hasMatch(keyEvent.key)) {
        keyEvent.preventDefault();
      }
    }).toJS;
    web.document.addEventListener('keydown', _keydownListener!);
  }

  @override
  void initState() {
    _pinController = TextEditingController(text: widget.pin ?? '');
    _focusNode = FocusNode();

    if (kIsWeb) {
      _setupGlobalKeyListener();
    } else {
      _keyboardFocusNode = FocusNode();
    }

    if (!_isLoggedIn) _signin();
    _resetUrl();
    super.initState();
  }

  @override
  void dispose() {
    if (kIsWeb && _keydownListener != null) {
      web.document.removeEventListener('keydown', _keydownListener!);
    } else if (_keyboardFocusNode != null) {
      _keyboardFocusNode?.dispose();
    }
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
                          enabled: !kIsWeb,
                          keyboardType: TextInputType.number,
                          onChanged: kIsWeb
                              ? null
                              : (value) {
                                  setState(() => _pinController.text = value);
                                },
                          onSubmitted: kIsWeb
                              ? null
                              : (value) {
                                  if (isValidPin) _onPressed();
                                },
                          inputFormatters: kIsWeb
                              ? const <TextInputFormatter>[]
                              : [FullWidthDigitFormatter(), FilteringTextInputFormatter.digitsOnly],
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

    if (kIsWeb) {
      return child;
    } else {
      return KeyboardListener(focusNode: _keyboardFocusNode!, onKeyEvent: _onKey, child: child);
    }
  }
}
