class HeartbeatResponse {
  final String message;

  HeartbeatResponse({required this.message});

  factory HeartbeatResponse.fromJson(Map<String, dynamic> json) {
    return HeartbeatResponse(
      message: json['message'] as String? ?? 'Heartbeat updated successfully',
    );
  }
}