class EndGameResponse {
  final String message;

  EndGameResponse({required this.message});

  factory EndGameResponse.fromJson(Map<String, dynamic> json) {
    return EndGameResponse(message: json['message'] as String? ?? 'Game ended successfully');
  }
}