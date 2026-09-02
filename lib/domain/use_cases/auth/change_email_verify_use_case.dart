import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeEmailVerifyUseCase {
  final AuthRepository _repository;

  ChangeEmailVerifyUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call(String email, int otp) =>
      _repository.changeEmailVerify(email, otp);
}
