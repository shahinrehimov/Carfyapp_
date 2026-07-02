import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearAuthTokenUseCase {
  final AuthRepository _repository;

  ClearAuthTokenUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.clearAuthToken();
}
