import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/check_email_response.dart';
import '../../params/auth/check_email_params.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class CheckEmailUseCase {
  final AuthRepository _repository;
  CheckEmailUseCase(this._repository);

  Future<Either<Failure, CheckEmailResponse>> call(CheckEmailParams params) async {
    return await _repository.checkEmail(params: params);
  }
}
