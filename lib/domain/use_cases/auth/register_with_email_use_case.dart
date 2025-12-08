import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/register_email_response.dart';
import '../../params/auth/register_with_email_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class RegisterWithEmailUseCase {
  final AuthRepository _repository;
  RegisterWithEmailUseCase(this._repository);

  Future<Either<Failure, RegisterEmailResponse>> call(RegisterWithEmailParams params) async {
    return await _repository.registerWithEmail(params: params);
  }
}
