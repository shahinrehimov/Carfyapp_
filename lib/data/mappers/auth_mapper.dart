import 'package:injectable/injectable.dart';

import '../../domain/entities/auth/auth_session.dart';
import '../models/auth/login_response_model.dart';

abstract class AuthMapper {
  AuthSession mapLoginResponse(LoginResponseModel login);
}

@Injectable(as: AuthMapper)
class AuthMapperImpl extends AuthMapper {
  @override
  AuthSession mapLoginResponse(LoginResponseModel login) => AuthSession(token: login.token);
}
