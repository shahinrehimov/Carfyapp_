import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGuestIdentifierUseCase {
  final AuthRepository _repository;

  GetGuestIdentifierUseCase(this._repository);

  Future<Either<Failure, String?>> call() => _repository.getGuestIdentifier();
}
