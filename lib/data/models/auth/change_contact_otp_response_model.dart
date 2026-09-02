class ChangeContactOtpResponseModel {
  final String message;
  final int otpExpiresIn;

  const ChangeContactOtpResponseModel({required this.message, required this.otpExpiresIn});

  factory ChangeContactOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeContactOtpResponseModel(
      message: json['message'] ?? '',
      otpExpiresIn: json['otp_expires_in'] ?? 180,
    );
  }
}
