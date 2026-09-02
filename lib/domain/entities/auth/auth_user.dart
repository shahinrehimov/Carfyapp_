class AuthUser {
  final String uuid;
  final String email;
  final String phone;
  final String name;
  final String surname;
  final String? gender;
  final String? genderLabel;
  final String? birthDate;
  final bool emailIsVerified;
  final bool phoneIsVerified;
  final String? token;
  final String? image;
  final String? registerType;

  AuthUser({
    required this.uuid,
    required this.email,
    required this.phone,
    required this.name,
    required this.surname,
    this.gender,
    this.genderLabel,
    this.birthDate,
    required this.emailIsVerified,
    required this.phoneIsVerified,
    this.token,
    this.image,
    this.registerType,
  });

  String get fullName => '$name $surname';
}
