class ChangeEmailVerifyDto {
  final String email;
  final int otp;

  const ChangeEmailVerifyDto({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}
