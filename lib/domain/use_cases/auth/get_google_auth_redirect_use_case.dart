import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/google_auth_redirect.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class GetGoogleAuthRedirectUseCase {
  final AuthRepository _repository;
  GetGoogleAuthRedirectUseCase(this._repository);

  Future<Either<Failure, GoogleAuthRedirect>> call() async {
    return await _repository.getGoogleAuthRedirect();
  }
}
