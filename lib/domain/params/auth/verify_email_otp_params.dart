class VerifyEmailOtpParams {
  final String userUuid;
  final String email;
  final int otp;

  VerifyEmailOtpParams({required this.userUuid, required this.email, required this.otp});
}
