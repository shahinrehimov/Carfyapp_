import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAuthTokenUseCase {
  final AuthRepository _repository;

  SaveAuthTokenUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String token) => _repository.saveAuthToken(token);
}
