import 'dart:io';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileImageUseCase {
  final AuthRepository _repository;

  UpdateProfileImageUseCase(this._repository);

  Future<Either<Failure, AuthUser>> call(File image) => _repository.updateProfileImage(image);
}
