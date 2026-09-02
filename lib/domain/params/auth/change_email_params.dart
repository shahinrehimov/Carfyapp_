class ChangeEmailSendOtpParams {
  final String email;

  const ChangeEmailSendOtpParams({required this.email});
}

class ChangeEmailVerifyParams {
  final String email;
  final int otp;

  const ChangeEmailVerifyParams({required this.email, required this.otp});
}
