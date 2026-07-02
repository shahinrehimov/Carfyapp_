import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckLoggedUseCase {
  final AuthRepository _repository;

  CheckLoggedUseCase(this._repository);

  Future<Either<Failure, bool>> call() => _repository.isLoggedIn();
}
