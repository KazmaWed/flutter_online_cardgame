class SubmitResponse {
  final String message;

  SubmitResponse({required this.message});

  factory SubmitResponse.fromJson(Map<String, dynamic> json) {
    return SubmitResponse(
      message: json['message'] as String? ?? 'Submit time recorded successfully',
    );
  }
}
