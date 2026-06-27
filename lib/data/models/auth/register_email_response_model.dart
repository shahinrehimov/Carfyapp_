import 'package:carfy/data/models/auth/auth_user_model.dart';

class RegisterEmailResponseModel {
  final String step;
  final AuthUserModel user;
  final String message;

  RegisterEmailResponseModel({required this.step, required this.user, required this.message});

  factory RegisterEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterEmailResponseModel(
      step: json['step'] ?? '',
      user: AuthUserModel.fromJson(json['user']),
      message: json['message'] ?? '',
    );
  }
}
