import '../dtos/auth/login_request_dto.dart';
import '../models/auth/login_response_model.dart';

abstract class AuthDataSource {
  Future<LoginResponseModel> login(LoginRequestDto request);
}
