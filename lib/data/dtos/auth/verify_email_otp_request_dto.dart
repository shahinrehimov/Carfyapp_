class VerifyEmailOtpRequestDto {
  final String userUuid;
  final String email;
  final int otp;

  VerifyEmailOtpRequestDto({
    required this.userUuid,
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'user_uuid': userUuid,
    'email': email,
    'otp': otp,
  };
}
