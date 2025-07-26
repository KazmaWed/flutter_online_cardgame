class EnterGameResponse {
  final String gameId;
  final String password;
  final String message;

  EnterGameResponse({required this.gameId, required this.password, required this.message});

  factory EnterGameResponse.fromJson(Map<String, dynamic> json) {
    return EnterGameResponse(
      gameId: json['gameId'] as String? ?? '',
      password: json['password'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'EnterGameResponse(gameId: $gameId, password: $password, message: $message)';
  }
}
