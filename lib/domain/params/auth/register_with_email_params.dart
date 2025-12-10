class RegisterWithEmailParams {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;

  RegisterWithEmailParams({
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });
}
