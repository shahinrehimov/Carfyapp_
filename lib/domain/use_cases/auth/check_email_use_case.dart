import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/check_email_response.dart';
import 'package:carfy/domain/params/auth/check_email_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class CheckEmailUseCase {
  final AuthRepository _repository;
  CheckEmailUseCase(this._repository);

  Future<Either<Failure, CheckEmailResponse>> call(CheckEmailParams params) async {
    return await _repository.checkEmail(params: params);
  }
}
