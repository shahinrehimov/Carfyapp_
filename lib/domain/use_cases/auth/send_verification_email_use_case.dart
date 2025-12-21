import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class SendVerificationEmailUseCase {
  final AuthRepository _repository;
  SendVerificationEmailUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.sendVerificationEmail();
  }
}
