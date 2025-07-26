enum GamePhase {
  matching, // 0: マッチング段階
  playing, // 1: ゲーム開始後
  finished, // 2: 終了（拡張用）
}

extension GamePhaseExtension on GamePhase {
  int get value {
    switch (this) {
      case GamePhase.matching:
        return 0;
      case GamePhase.playing:
        return 1;
      case GamePhase.finished:
        return 2;
    }
  }

  static GamePhase fromInt(int phase) {
    switch (phase) {
      case 0:
        return GamePhase.matching;
      case 1:
        return GamePhase.playing;
      case 2:
        return GamePhase.finished;
      default:
        throw ArgumentError('Invalid phase value: $phase');
    }
  }

  bool get isMatching => this == GamePhase.matching;
  bool get isPlaying => this == GamePhase.playing;
  bool get isFinished => this == GamePhase.finished;
}
