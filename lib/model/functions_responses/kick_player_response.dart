class KickPlayerResponse {
  final String message;

  KickPlayerResponse({required this.message});

  factory KickPlayerResponse.fromJson(Map<String, dynamic> json) {
    return KickPlayerResponse(message: json['message'] as String? ?? 'Player kicked successfully');
  }
}
