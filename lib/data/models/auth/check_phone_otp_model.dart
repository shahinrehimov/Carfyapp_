class CheckPhoneOtpModel {
  final String step;
  final String phoneConfirmationToken;
  final String message;

  CheckPhoneOtpModel({required this.step, required this.phoneConfirmationToken, required this.message});

  factory CheckPhoneOtpModel.fromJson(Map<String, dynamic> json) {
    return CheckPhoneOtpModel(
      step: json['step'] ?? '',
      phoneConfirmationToken: json['phone_confirmation_token'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
