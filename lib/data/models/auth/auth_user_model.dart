class AuthUserModel {
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

  AuthUserModel({
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

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      uuid: json['uuid'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      gender: json['gender'],
      genderLabel: json['gender_label'],
      birthDate: json['birth_date'],
      emailIsVerified: json['email_is_verified'] ?? false,
      phoneIsVerified: json['phone_is_verified'] ?? false,
      token: json['token'],
      image: json['image'],
      registerType: json['register_type'],
    );
  }
}
