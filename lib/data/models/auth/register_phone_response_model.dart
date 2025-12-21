import 'package:carfy/data/models/auth/auth_user_model.dart';

class RegisterPhoneResponseModel {
  final String step;
  final AuthUserModel user;
  final String message;

  RegisterPhoneResponseModel({
    required this.step,
    required this.user,
    required this.message,
  });

  factory RegisterPhoneResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterPhoneResponseModel(
      step: json['step'] ?? '',
      user: AuthUserModel.fromJson(json['user']),
      message: json['message'] ?? '',
    );
  }
}