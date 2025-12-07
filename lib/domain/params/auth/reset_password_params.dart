class ResetPasswordParams {
  final String resetToken;
  final String email;
  final String password;
  final String passwordConfirmation;

  ResetPasswordParams({
    required this.resetToken,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}
