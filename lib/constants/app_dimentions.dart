/// アプリ内のWidgetサイズ定数を一元管理するクラス
class AppDimentions {
  AppDimentions._(); // インスタンス化防止

  static const double screenWidth = 720.0; // 例: デフォルトの画面幅
  static const double screenWidthThin = 540.0; // 例: スリムな画面幅
  static const double screenWidthNarrow = 640.0; // 例: ナロウな画面幅
  static const double screenWidthExtraThin = 360.0; // 例: エクストラスリムな画面幅
  static const double imageSize = 480.0; // 例: デフォルトの画面高さ

  static const double paddingMicro = 4.0; // 例: デフォルトの画面高さ
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;

  static const double buttonWidth = 100.0; // ボタンの幅
  static const double buttonHeight = 48.0;

  static const double hintCardHeightHigh = 110.0; // カードの高さ
  static const double hintCardHeightLow = 80.0; // カードの高さ

  static const double avatarSizeL = 80.0; // アバターのサイズ
  static const double avatarSizeS = 48.0; // アバターのサイズ
  static const double avatarSizeXS = 36.0; // アバターのサイズ

  static const double resultColumnOrder = 48; // 結果画面の列幅
  static const double resultColumnValue = 32; // 結果画面の列幅
  static const double resultColumnIcon = 36; // 結果画面の列幅

  static const double resultCircleSize = 120; // 結果画面の列幅
  static const double iconButtonSize = 32; // アイコンボタンのサイズ
}
