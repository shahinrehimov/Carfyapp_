import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveGuestIdentifierUseCase {
  final AuthRepository _repository;

  SaveGuestIdentifierUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) => _repository.saveGuestIdentifier(id);
}
