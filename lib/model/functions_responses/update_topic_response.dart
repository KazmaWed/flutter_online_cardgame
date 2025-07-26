class UpdateTopicResponse {
  final String message;

  UpdateTopicResponse({required this.message});

  factory UpdateTopicResponse.fromJson(Map<String, dynamic> json) {
    return UpdateTopicResponse(message: json['message'] as String? ?? 'Topic updated successfully');
  }
}
