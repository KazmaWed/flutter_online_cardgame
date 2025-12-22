import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_online_cardgame/constants/app_constants.dart';
import 'package:flutter_online_cardgame/constants/app_fonts.dart';
import 'package:flutter_online_cardgame/firebase_options.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/providers/locale_provider.dart';
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
      webProvider: ReCaptchaV3Provider(const String.fromEnvironment('RECAPTCHA_SITE_KEY')),
    );

    // Initialize Firebase Analytics
    FirebaseAnalytics.instance;

    // Initialize Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  final _surfaceColor = Colors.white;
  final _seedColor = Colors.pink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale(AppConstants.japaneseCode), Locale(AppConstants.englishCode)],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor).copyWith(surface: _surfaceColor),
        fontFamily: AppFonts.zenMaruGothic,
      ),
      home: const StartupScreen(),
    );
  }
}
