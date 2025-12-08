import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/forgot_password_response.dart';
import '../../params/auth/forgot_password_params.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, ForgotPasswordResponse>> call(ForgotPasswordParams params) async {
    return await _repository.forgotPassword(params: params);
  }
}
