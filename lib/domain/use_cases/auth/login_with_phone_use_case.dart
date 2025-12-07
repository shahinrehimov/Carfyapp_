import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/login_response.dart';
import '../../params/auth/login_with_phone_submit_params.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class LoginWithPhoneUseCase {
  final AuthRepository _repository;
  LoginWithPhoneUseCase(this._repository);

  Future<Either<Failure, LoginResponse>> call(LoginWithPhoneSubmitParams params) async {
    return await _repository.loginWithPhone(params: params);
  }
}
