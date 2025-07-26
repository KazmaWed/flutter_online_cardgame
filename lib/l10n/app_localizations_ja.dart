// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'どんぐりの背比べゲーム';

  @override
  String get createNewGame => 'ルームを作成';

  @override
  String get joinGame => 'ルームに参加';

  @override
  String get howToPlay => '遊び方を見る';

  @override
  String get joinGameTitle => 'ルームに参加';

  @override
  String get enterCodeInstruction => '4桁のコードを入力';

  @override
  String get join => '参加';

  @override
  String get matchingTitle => 'マッチング';

  @override
  String get password => 'パスワード';

  @override
  String get sharePasswordInstruction =>
      '他のプレイヤーにパスワードを伝えるか\n招待URLをコピーして共有してください';

  @override
  String get urlCopiedMessage => '招待URLをコピーしました';

  @override
  String get tapToCopyInviteUrl => 'タップで招待URLをコピー';

  @override
  String get you => 'あなた';

  @override
  String get avatar => 'アバター';

  @override
  String get selectAvatar => 'アバターを選択';

  @override
  String get enterPlayerNameInstruction => 'すてきなプレイヤー名を設定してください';

  @override
  String get playerNameLabel => 'プレイヤー名';

  @override
  String get setTopicInstruction => 'みんなで話し合うトピックを設定してください';

  @override
  String get topicLabel => 'トピック';

  @override
  String get startGame => 'ゲーム開始';

  @override
  String get kickPlayerTitle => 'プレイヤーをキックする';

  @override
  String get noPlayersMessage => '参加中のプレイヤーがいません';

  @override
  String get cancel => '取消';

  @override
  String get submit => '送信';

  @override
  String get topic => 'トピック';

  @override
  String get everyonesAnswers => 'みんなの答え';

  @override
  String get yourNumberIs => 'あなたの数字は';

  @override
  String get desu => 'です。';

  @override
  String get viewResults => '結果を見る';

  @override
  String get results => 'リザルト';

  @override
  String get correctAnswers => '正解数';

  @override
  String get scoreSeparator => '/';

  @override
  String get perfectGameMessage => 'とても良いどんぐりの背比べでした！';

  @override
  String get goodGameMessage => 'まあまあ良いどんぐりの背比べでした';

  @override
  String get correctAnswersAnnouncement => '正解発表';

  @override
  String get startNewGame => '新しいゲームを開始';

  @override
  String get playerHeader => 'プレイヤー';

  @override
  String get hintHeader => '出したヒント';

  @override
  String get numberHeader => '数字';

  @override
  String get guessHeader => '予想';

  @override
  String get correctHeader => '正解';

  @override
  String get numberSuffix => '番';

  @override
  String get errorTitle => 'Error';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get gameNotFound => 'ゲームがありません';

  @override
  String get loginFailed => 'ログインできません';

  @override
  String get defaultName => 'ナナシ';

  @override
  String get defaultHint => 'ヒントなし';

  @override
  String get userNotAuthenticated => 'User is not authenticated.';

  @override
  String get playerNotFound => 'Player data not found for user:';

  @override
  String get noGameWithPassword => 'No game found with the given password.';

  @override
  String get gameWatchFailed => 'Failed to watch game by ID:';

  @override
  String get confirmExitGameTitle => '退出しますか？';

  @override
  String get confirmExitGameMessage => '退室してもゲームは継続します';

  @override
  String get exitGame => '退出する';

  @override
  String get flutterDemoTitle => 'Flutter Demo';

  @override
  String hintTemplate(int value, String topic) {
    return '1~100のうち$valueくらい「$topic」なモノを入力';
  }

  @override
  String submitOrderText(int order) {
    return '$order 番';
  }

  @override
  String playerNotFoundError(String playerId) {
    return 'Player data not found for user: $playerId';
  }

  @override
  String gameWatchError(String error) {
    return 'Failed to watch game by ID: $error';
  }
}
