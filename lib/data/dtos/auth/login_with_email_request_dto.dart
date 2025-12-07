import 'package:carfy/common/constants/constants.dart';

class LoginWithEmailRequestDto {
  final String email;
  final String password;

  LoginWithEmailRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'device_type': Constants.deviceType, 'email': email, 'password': password};
}
