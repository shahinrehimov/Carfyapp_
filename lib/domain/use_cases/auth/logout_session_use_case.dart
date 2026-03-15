import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutSessionUseCase {
  final AuthRepository _repository;
  LogoutSessionUseCase(this._repository);

  Future<Either<Failure, String>> call(int tokenId) => _repository.logoutSession(tokenId);
}
