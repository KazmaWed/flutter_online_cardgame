class ExitGameResponse {
  final String message;

  ExitGameResponse({required this.message});

  factory ExitGameResponse.fromJson(Map<String, dynamic> json) {
    return ExitGameResponse(message: json['message'] as String? ?? 'Successfully exited game');
  }
}
