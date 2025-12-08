import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/login_response.dart';
import '../../params/auth/login_with_email_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;
  LoginWithEmailUseCase(this._repository);

  Future<Either<Failure, LoginResponse>> call(LoginWithEmailParams params) async {
    return await _repository.loginWithEmail(params: params);
  }
}
