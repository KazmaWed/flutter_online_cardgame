class AppConstants {
  AppConstants._(); // インスタンス化防止

  static const Duration playerLifeTime = Duration(seconds: 30); // プレイヤーのタイムアウト時間（秒）
  static const Duration authSigninDelay = Duration(seconds: 4); // ゲーム開始前の待機時間（秒）
  static const Duration scoreAnimationDuration = Duration(milliseconds: 2000); // スコアアニメーションの再生時間
  static const int maxPlayers = 10; // 最大プレイヤー数
  static const int maxPlayerNameLength = 6; // プレイヤー名の最大文字数
  static const int maxPlayerHintLength = 15; // プレイヤーのヒントの最大文字数
  static const int maxTopicLength = 20; // 最大トピック数
}
