class UpdateAvatarResponse {
  final String message;

  UpdateAvatarResponse({required this.message});

  factory UpdateAvatarResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAvatarResponse(
      message: json['message'] as String? ?? 'Avatar updated successfully',
    );
  }
}
