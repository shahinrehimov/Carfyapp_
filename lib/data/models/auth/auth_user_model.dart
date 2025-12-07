class AuthUserModel {
  final String uuid;
  final String email;
  final String phone;
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final bool emailIsVerified;
  final bool phoneIsVerified;
  final String? token;

  AuthUserModel({
    required this.uuid,
    required this.email,
    required this.phone,
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.emailIsVerified,
    required this.phoneIsVerified,
    this.token,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      uuid: json['uuid'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      gender: json['gender'],
      birthDate: json['birth_date'],
      emailIsVerified: json['email_is_verified'] ?? false,
      phoneIsVerified: json['phone_is_verified'] ?? false,
      token: json['token'],
    );
  }
}
