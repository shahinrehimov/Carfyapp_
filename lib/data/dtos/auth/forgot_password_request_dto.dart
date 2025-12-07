class ForgotPasswordRequestDto {
  final String email;

  ForgotPasswordRequestDto({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
