import 'auth_user.dart';

class RegisterEmailResponse {
  final String step;
  final AuthUser user;
  final String message;

  RegisterEmailResponse({
    required this.step,
    required this.user,
    required this.message,
  });
}
