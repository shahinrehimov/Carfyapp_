class ChangePhoneSendOtpDto {
  final String phone;

  const ChangePhoneSendOtpDto({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
