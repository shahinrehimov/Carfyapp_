import 'package:carfy/common/constants/constants.dart';

class RegisterWithEmailRequestDto {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;

  RegisterWithEmailRequestDto({
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'device_type': Constants.deviceType,
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
