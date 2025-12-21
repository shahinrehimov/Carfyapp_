import 'package:carfy/domain/enums/gender.dart';

class RegisterWithPhoneParams {
  final String name;
  final String surname;
  final Gender? gender;
  final DateTime? birthDate;
  final String email;
  final String phone;
  final String phoneConfirmationToken;
  final int otp;

  RegisterWithPhoneParams({
    required this.name,
    required this.surname,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.phoneConfirmationToken,
    required this.otp,
  });
}
