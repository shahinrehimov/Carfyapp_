import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteProfileImageUseCase {
  final AuthRepository _repository;

  DeleteProfileImageUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.deleteProfileImage();
}
