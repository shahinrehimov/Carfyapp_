class ChangeContactOtpResponse {
  final String message;
  final int otpExpiresIn;

  const ChangeContactOtpResponse({required this.message, required this.otpExpiresIn});
}
