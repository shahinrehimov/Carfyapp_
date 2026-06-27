class CheckPhoneOtpRequestDto {
  final String phone;
  final int otp;

  CheckPhoneOtpRequestDto({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}
