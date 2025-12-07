class SendPhoneOtpRequestDto {
  final String phone;

  SendPhoneOtpRequestDto({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
