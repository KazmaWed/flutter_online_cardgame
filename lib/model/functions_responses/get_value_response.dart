class GetValueResponse {
  final String gameId;
  final int value;

  GetValueResponse({required this.gameId, required this.value});

  factory GetValueResponse.fromJson(Map<String, dynamic> json) {
    return GetValueResponse(gameId: json['gameId'] as String, value: json['value'] as int);
  }
}
