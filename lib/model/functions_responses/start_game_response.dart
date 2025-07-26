class StartGameResponse {
  final String message;

  StartGameResponse({required this.message});

  factory StartGameResponse.fromJson(Map<String, dynamic> json) {
    return StartGameResponse(message: json['message'] as String? ?? 'Game started successfully');
  }
}
