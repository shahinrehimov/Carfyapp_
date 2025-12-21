import 'package:carfy/domain/entities/auth/auth_user.dart';

class LoginResponse {
  final AuthUser data;
  final String token;

  LoginResponse({required this.data, required this.token});
}
