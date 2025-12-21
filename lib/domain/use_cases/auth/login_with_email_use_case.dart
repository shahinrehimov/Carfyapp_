import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/params/auth/login_with_email_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;
  LoginWithEmailUseCase(this._repository);

  Future<Either<Failure, LoginResponse>> call(LoginWithEmailParams params) async {
    return await _repository.loginWithEmail(params: params);
  }
}
