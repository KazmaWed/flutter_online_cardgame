class UpdateNameResponse {
  final String message;

  UpdateNameResponse({required this.message});

  factory UpdateNameResponse.fromJson(Map<String, dynamic> json) {
    return UpdateNameResponse(message: json['message'] as String? ?? 'Name updated successfully');
  }
}
