class ChangeEmailSendOtpDto {
  final String email;

  const ChangeEmailSendOtpDto({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
