import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/forgot_password_response.dart';
import 'package:carfy/domain/params/auth/forgot_password_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, ForgotPasswordResponse>> call(ForgotPasswordParams params) async {
    return await _repository.forgotPassword(params: params);
  }
}
