import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAuthTokenUseCase {
  final AuthRepository _repository;

  GetAuthTokenUseCase(this._repository);

  Future<Either<Failure, String?>> call() => _repository.getAuthToken();
}
