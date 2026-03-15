class RegisterWithEmailRequestDto {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String deviceName;

  RegisterWithEmailRequestDto({
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'device_type': deviceName,
    'name': name,
    'surname': surname,
    'gender': gender,
    'birth_date': birthDate,
    'email': email,
    'phone': phone,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };
}
