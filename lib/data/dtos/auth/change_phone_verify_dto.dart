class ChangePhoneVerifyDto {
  final String phone;
  final int otp;

  const ChangePhoneVerifyDto({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}
