class ResetPasswordRequestDto {
  final String resetToken;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestDto({
    required this.resetToken,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'reset_token': resetToken,
    'email': email,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}
