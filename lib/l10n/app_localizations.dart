import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ja')];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'どんぐりの背比べゲーム'**
  String get appTitle;

  /// No description provided for @createNewGame.
  ///
  /// In ja, this message translates to:
  /// **'ルームを作成'**
  String get createNewGame;

  /// No description provided for @joinGame.
  ///
  /// In ja, this message translates to:
  /// **'ルームに参加'**
  String get joinGame;

  /// No description provided for @howToPlay.
  ///
  /// In ja, this message translates to:
  /// **'遊び方を見る'**
  String get howToPlay;

  /// No description provided for @start.
  ///
  /// In ja, this message translates to:
  /// **'はじめる'**
  String get start;

  /// No description provided for @joinGameTitle.
  ///
  /// In ja, this message translates to:
  /// **'ルームに参加'**
  String get joinGameTitle;

  /// No description provided for @enterCodeInstruction.
  ///
  /// In ja, this message translates to:
  /// **'4桁のコードを入力'**
  String get enterCodeInstruction;

  /// No description provided for @join.
  ///
  /// In ja, this message translates to:
  /// **'参加'**
  String get join;

  /// No description provided for @matchingTitle.
  ///
  /// In ja, this message translates to:
  /// **'マッチング'**
  String get matchingTitle;

  /// No description provided for @password.
  ///
  /// In ja, this message translates to:
  /// **'パスワード'**
  String get password;

  /// No description provided for @sharePasswordInstruction.
  ///
  /// In ja, this message translates to:
  /// **'他のプレイヤーにパスワードを伝えるか\n招待URLをコピーして共有してください'**
  String get sharePasswordInstruction;

  /// No description provided for @urlCopiedMessage.
  ///
  /// In ja, this message translates to:
  /// **'招待URLをコピーしました'**
  String get urlCopiedMessage;

  /// No description provided for @tapToCopyInviteUrl.
  ///
  /// In ja, this message translates to:
  /// **'タップで招待URLをコピー'**
  String get tapToCopyInviteUrl;

  /// No description provided for @copyInviteShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'タップで招待URLをコピーして、ほかのプレイヤーに共有しましょう'**
  String get copyInviteShowcaseDescription;

  /// No description provided for @you.
  ///
  /// In ja, this message translates to:
  /// **'あなた'**
  String get you;

  /// No description provided for @avatar.
  ///
  /// In ja, this message translates to:
  /// **'アバター'**
  String get avatar;

  /// No description provided for @selectAvatar.
  ///
  /// In ja, this message translates to:
  /// **'アバターを選択'**
  String get selectAvatar;

  /// No description provided for @selectAvatarShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'アバターを選択してください'**
  String get selectAvatarShowcaseDescription;

  /// No description provided for @enterPlayerNameInstruction.
  ///
  /// In ja, this message translates to:
  /// **'すてきなプレイヤー名を設定してください'**
  String get enterPlayerNameInstruction;

  /// No description provided for @enterPlayerNameShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー名を入力してください'**
  String get enterPlayerNameShowcaseDescription;

  /// No description provided for @playerNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー名'**
  String get playerNameLabel;

  /// No description provided for @participants.
  ///
  /// In ja, this message translates to:
  /// **'参加者'**
  String get participants;

  /// No description provided for @recommendedTopics.
  ///
  /// In ja, this message translates to:
  /// **'おすすめトピック'**
  String get recommendedTopics;

  /// No description provided for @notSet.
  ///
  /// In ja, this message translates to:
  /// **'未設定'**
  String get notSet;

  /// No description provided for @setTopicInstruction.
  ///
  /// In ja, this message translates to:
  /// **'みんなで話し合うトピックを入力してください'**
  String get setTopicInstruction;

  /// No description provided for @setTopicShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'みんなで話し合うトピックを入力してください\nおすすめからも選べます'**
  String get setTopicShowcaseDescription;

  /// No description provided for @topicLabel.
  ///
  /// In ja, this message translates to:
  /// **'トピック'**
  String get topicLabel;

  /// No description provided for @startGame.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム開始'**
  String get startGame;

  /// No description provided for @kickPlayerTitle.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤーをキックする'**
  String get kickPlayerTitle;

  /// No description provided for @noPlayersMessage.
  ///
  /// In ja, this message translates to:
  /// **'参加中のプレイヤーがいません'**
  String get noPlayersMessage;

  /// No description provided for @kick.
  ///
  /// In ja, this message translates to:
  /// **'キック'**
  String get kick;

  /// No description provided for @chooseFromPresets.
  ///
  /// In ja, this message translates to:
  /// **'おすすめ\nから選ぶ'**
  String get chooseFromPresets;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get submit;

  /// No description provided for @topic.
  ///
  /// In ja, this message translates to:
  /// **'トピック'**
  String get topic;

  /// No description provided for @everyonesAnswers.
  ///
  /// In ja, this message translates to:
  /// **'みんなの答え'**
  String get everyonesAnswers;

  /// No description provided for @yourNumberIs.
  ///
  /// In ja, this message translates to:
  /// **'あなたの数字は'**
  String get yourNumberIs;

  /// No description provided for @desu.
  ///
  /// In ja, this message translates to:
  /// **'です。'**
  String get desu;

  /// No description provided for @playingTopicShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'今回のお題です、他のプレイヤーにも見えています'**
  String get playingTopicShowcaseDescription;

  /// No description provided for @playingNumberShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'あなたの数字です、他のプレイヤーには見えません'**
  String get playingNumberShowcaseDescription;

  /// No description provided for @playingHintShowcaseDescription.
  ///
  /// In ja, this message translates to:
  /// **'数字の大きさを表す、トピックに沿ったヒントを入力してください'**
  String get playingHintShowcaseDescription;

  /// No description provided for @viewResults.
  ///
  /// In ja, this message translates to:
  /// **'結果を見る'**
  String get viewResults;

  /// Shows how many players have submitted their hints
  ///
  /// In ja, this message translates to:
  /// **'{sent}人中{total}人送信済み'**
  String submissionStatus(int sent, int total);

  /// Instructions for when to submit based on rank
  ///
  /// In ja, this message translates to:
  /// **'{rank, plural, =1{1番小さいと思ったら送信} other{{rank}番目に小さいと思ったら送信}}'**
  String submitInstruction(int rank);

  /// No description provided for @submitInstructionWithOrdinal.
  ///
  /// In ja, this message translates to:
  /// **'{ordinal}小さいと思ったら送信'**
  String submitInstructionWithOrdinal(Object ordinal);

  /// Shows the order in which the player submitted
  ///
  /// In ja, this message translates to:
  /// **'{order}番目に送信済み'**
  String submitted(int order);

  /// No description provided for @hint.
  ///
  /// In ja, this message translates to:
  /// **'ヒント'**
  String get hint;

  /// No description provided for @results.
  ///
  /// In ja, this message translates to:
  /// **'リザルト'**
  String get results;

  /// No description provided for @correctAnswers.
  ///
  /// In ja, this message translates to:
  /// **'正解数'**
  String get correctAnswers;

  /// No description provided for @scoreSeparator.
  ///
  /// In ja, this message translates to:
  /// **'/'**
  String get scoreSeparator;

  /// No description provided for @perfectGameMessage.
  ///
  /// In ja, this message translates to:
  /// **'とても良いどんぐりの背比べでした！'**
  String get perfectGameMessage;

  /// No description provided for @goodGameMessage.
  ///
  /// In ja, this message translates to:
  /// **'まあまあ良いどんぐりの背比べでした'**
  String get goodGameMessage;

  /// No description provided for @correctAnswersAnnouncement.
  ///
  /// In ja, this message translates to:
  /// **'正解発表'**
  String get correctAnswersAnnouncement;

  /// No description provided for @startNewGame.
  ///
  /// In ja, this message translates to:
  /// **'新しいゲームを開始'**
  String get startNewGame;

  /// No description provided for @playerHeader.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー'**
  String get playerHeader;

  /// No description provided for @hintHeader.
  ///
  /// In ja, this message translates to:
  /// **'出したヒント'**
  String get hintHeader;

  /// No description provided for @numberHeader.
  ///
  /// In ja, this message translates to:
  /// **'数字'**
  String get numberHeader;

  /// No description provided for @guessHeader.
  ///
  /// In ja, this message translates to:
  /// **'予想'**
  String get guessHeader;

  /// No description provided for @correctHeader.
  ///
  /// In ja, this message translates to:
  /// **'正解'**
  String get correctHeader;

  /// No description provided for @numberSuffix.
  ///
  /// In ja, this message translates to:
  /// **'番'**
  String get numberSuffix;

  /// No description provided for @errorTitle.
  ///
  /// In ja, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @unexpectedError.
  ///
  /// In ja, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @gameNotFound.
  ///
  /// In ja, this message translates to:
  /// **'ゲームがありません'**
  String get gameNotFound;

  /// No description provided for @loginFailed.
  ///
  /// In ja, this message translates to:
  /// **'ログインできません'**
  String get loginFailed;

  /// No description provided for @defaultName.
  ///
  /// In ja, this message translates to:
  /// **'ナナシ'**
  String get defaultName;

  /// No description provided for @defaultHint.
  ///
  /// In ja, this message translates to:
  /// **'ヒントなし'**
  String get defaultHint;

  /// No description provided for @userNotAuthenticated.
  ///
  /// In ja, this message translates to:
  /// **'User is not authenticated.'**
  String get userNotAuthenticated;

  /// No description provided for @playerNotFound.
  ///
  /// In ja, this message translates to:
  /// **'Player data not found for user:'**
  String get playerNotFound;

  /// No description provided for @noGameWithPassword.
  ///
  /// In ja, this message translates to:
  /// **'No game found with the given password.'**
  String get noGameWithPassword;

  /// No description provided for @gameWatchFailed.
  ///
  /// In ja, this message translates to:
  /// **'Failed to watch game by ID:'**
  String get gameWatchFailed;

  /// No description provided for @confirmExitGameTitle.
  ///
  /// In ja, this message translates to:
  /// **'退出しますか？'**
  String get confirmExitGameTitle;

  /// No description provided for @confirmExitGameMessage.
  ///
  /// In ja, this message translates to:
  /// **'退室してもゲームは継続します'**
  String get confirmExitGameMessage;

  /// No description provided for @exitGame.
  ///
  /// In ja, this message translates to:
  /// **'退出する'**
  String get exitGame;

  /// No description provided for @flutterDemoTitle.
  ///
  /// In ja, this message translates to:
  /// **'Flutter Demo'**
  String get flutterDemoTitle;

  /// No description provided for @dataLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'データの読み込みに失敗しました'**
  String get dataLoadFailed;

  /// No description provided for @cancelButton.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancelButton;

  /// No description provided for @github.
  ///
  /// In ja, this message translates to:
  /// **'Github'**
  String get github;

  /// No description provided for @license.
  ///
  /// In ja, this message translates to:
  /// **'ライセンス'**
  String get license;

  /// No description provided for @howToPlayTitle.
  ///
  /// In ja, this message translates to:
  /// **'遊び方'**
  String get howToPlayTitle;

  /// No description provided for @instructionLoadFailed.
  ///
  /// In ja, this message translates to:
  /// **'説明を読み込めませんでした'**
  String get instructionLoadFailed;

  /// No description provided for @reload.
  ///
  /// In ja, this message translates to:
  /// **'リロード'**
  String get reload;

  /// No description provided for @notSubmitted.
  ///
  /// In ja, this message translates to:
  /// **'未送信'**
  String get notSubmitted;

  /// No description provided for @playerId.
  ///
  /// In ja, this message translates to:
  /// **'ID: {playerId}'**
  String playerId(String playerId);

  /// No description provided for @hintTemplate.
  ///
  /// In ja, this message translates to:
  /// **'1~100のうち{value}くらい「{topic}」に相応しいヒントを入力'**
  String hintTemplate(int value, String topic);

  /// No description provided for @submitOrderText.
  ///
  /// In ja, this message translates to:
  /// **'{order} 番'**
  String submitOrderText(int order);

  /// No description provided for @playerNotFoundError.
  ///
  /// In ja, this message translates to:
  /// **'Player data not found for user: {playerId}'**
  String playerNotFoundError(String playerId);

  /// No description provided for @gameWatchError.
  ///
  /// In ja, this message translates to:
  /// **'Failed to watch game by ID: {error}'**
  String gameWatchError(String error);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
