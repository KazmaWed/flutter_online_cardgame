class InitPlayerResponse {
  final String? gameId;

  const InitPlayerResponse({this.gameId});

  factory InitPlayerResponse.fromJson(Map<String, dynamic> json) {
    return InitPlayerResponse(gameId: json['gameId'] as String?);
  }

  @override
  String toString() {
    return 'InitPlayerResponse(gameId: $gameId)';
  }
}
