import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/logout_response.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  Future<Either<Failure, LogoutResponse>> call() async {
    return await _repository.logout();
  }
}
