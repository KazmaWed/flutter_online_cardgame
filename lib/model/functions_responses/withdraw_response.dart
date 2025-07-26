class WithdrawResponse {
  final String message;

  WithdrawResponse({required this.message});

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(message: json['message'] as String? ?? 'Submit withdrawn successfully');
  }
}
