import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../params/auth/reset_password_params.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;
  ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    return await _repository.resetPassword(params: params);
  }
}
