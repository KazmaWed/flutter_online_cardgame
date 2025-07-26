class UpdateHintResponse {
  final String message;

  UpdateHintResponse({required this.message});

  factory UpdateHintResponse.fromJson(Map<String, dynamic> json) {
    return UpdateHintResponse(message: json['message'] as String? ?? 'Hint updated successfully');
  }
}
