import 'auth_user_model.dart';

class LoginResponseModel {
  final AuthUserModel data;
  final String token;

  LoginResponseModel({
    required this.data,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      data: AuthUserModel.fromJson(json['data']),
      token: json['token'] ?? '',
    );
  }
}
