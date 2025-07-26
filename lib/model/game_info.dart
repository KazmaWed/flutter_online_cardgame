class GameInfo {
  final String gameId;
  final String password;

  GameInfo({required this.gameId, required this.password});

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    try {
      final password = json['password'] as String;
      return GameInfo(gameId: json['gameId'] as String, password: password);
    } catch (e) {
      throw FormatException('Invalid JSON format for CreateGameResponse');
    }
  }
}
