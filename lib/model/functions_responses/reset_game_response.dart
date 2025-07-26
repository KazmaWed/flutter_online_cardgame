class ResetGameResponse {
  final String message;

  ResetGameResponse({required this.message});

  factory ResetGameResponse.fromJson(Map<String, dynamic> json) {
    return ResetGameResponse(message: json['message'] as String? ?? 'Game reset successfully');
  }
}