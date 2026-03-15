import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/params/auth/update_profile_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call(UpdateProfileParams params) =>
      _repository.updateProfile(params: params);
}
