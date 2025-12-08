class LoginWithPhoneOtpRequestDto {
  final String phone;

  LoginWithPhoneOtpRequestDto({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
