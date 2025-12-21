import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/register_email_response.dart';
import 'package:carfy/domain/params/auth/register_with_email_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class RegisterWithEmailUseCase {
  final AuthRepository _repository;
  RegisterWithEmailUseCase(this._repository);

  Future<Either<Failure, RegisterEmailResponse>> call(RegisterWithEmailParams params) async {
    return await _repository.registerWithEmail(params: params);
  }
}
