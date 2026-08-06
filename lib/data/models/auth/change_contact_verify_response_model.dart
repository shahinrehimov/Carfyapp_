import 'package:carfy/data/models/auth/auth_user_model.dart';

class ChangeContactVerifyResponseModel {
  final AuthUserModel user;
  final String message;

  const ChangeContactVerifyResponseModel({required this.user, required this.message});

  factory ChangeContactVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangeContactVerifyResponseModel(
      user: AuthUserModel.fromJson(json['user']),
      message: json['message'] ?? '',
    );
  }
}
