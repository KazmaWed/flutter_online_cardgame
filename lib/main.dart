import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_online_cardgame/constants/app_fonts.dart';
import 'package:flutter_online_cardgame/firebase_options.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/screens/startup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    // Use emulators for Firebase services in debug mode
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  } else {
    // Enable Firebase App Check in production
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider(
        const String.fromEnvironment('RECAPTCHA_SITE_KEY')
      ),
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'どんぐりの背比べゲーム',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        // Locale('en'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown).copyWith(surface: Colors.white),
        fontFamily: AppFonts.zenMaruGothic,
      ),
      home: const StartupScreen(),
    );
  }
}
