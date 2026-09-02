class ChangePhoneSendOtpParams {
  final String phone;

  const ChangePhoneSendOtpParams({required this.phone});
}

class ChangePhoneVerifyParams {
  final String phone;
  final int otp;

  const ChangePhoneVerifyParams({required this.phone, required this.otp});
}
