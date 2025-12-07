import 'auth_user.dart';

class RegisterPhoneResponse {
  final String step;
  final AuthUser user;
  final String message;

  RegisterPhoneResponse({
    required this.step,
    required this.user,
    required this.message,
  });
}
