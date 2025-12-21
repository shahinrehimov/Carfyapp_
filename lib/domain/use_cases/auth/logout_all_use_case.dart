import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/logout_response.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class LogoutAllUseCase {
  final AuthRepository _repository;
  LogoutAllUseCase(this._repository);

  Future<Either<Failure, LogoutResponse>> call() async {
    return await _repository.logoutAll();
  }
}
