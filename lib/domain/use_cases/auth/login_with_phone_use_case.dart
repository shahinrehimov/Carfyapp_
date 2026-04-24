import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/params/auth/login_with_phone_submit_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class LoginWithPhoneUseCase {
  final AuthRepository _repository;
  LoginWithPhoneUseCase(this._repository);

  Future<Either<Failure, LoginResponse>> call(LoginWithPhoneSubmitParams params) async {
    return await _repository.loginWithPhone(params: params);
  }
}
