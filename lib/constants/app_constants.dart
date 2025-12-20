class AppConstants {
  AppConstants._(); // インスタンス化防止

  static const Duration playerLifeTime = Duration(seconds: 30); // プレイヤーのタイムアウト時間（秒）
  static const Duration authSigninDelay = Duration(seconds: 4); // ゲーム開始前の待機時間（秒）
  static const Duration scoreAnimationDuration = Duration(milliseconds: 2000); // スコアアニメーションの再生時間
  static const int maxPlayers = 10; // 最大プレイヤー数
  static const int maxPlayerNameLength = 12; // プレイヤー名の最大文字数（非ASCII文字は2文字でカウント）
  static const int maxPlayerHintLength = 30; // プレイヤーのヒントの最大文字数（非ASCII文字は2文字でカウント）
  static const int maxTopicLength = 40; // 最大トピック数（非ASCII文字は2文字でカウント）
  static const double showcaseBarrierOpacity = 0.3; // ShowcaseViewのバリアパディング

  // Language codes
  static const List<String> japaneseCodes = ['ja', 'jp']; // 日本語として認識する言語コード
  static const String japaneseCode = 'ja'; // 日本語の正規化された言語コード
  static const String englishCode = 'en'; // 英語の言語コード

  // URL query parameters
  static const String queryParamLang = 'lang'; // 言語指定のクエリパラメータ名
  static const String queryParamPin = 'pin'; // PINコードのクエリパラメータ名
}
