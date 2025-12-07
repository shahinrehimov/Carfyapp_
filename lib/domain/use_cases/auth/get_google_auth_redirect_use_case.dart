import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/google_auth_redirect.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class GetGoogleAuthRedirectUseCase {
  final AuthRepository _repository;
  GetGoogleAuthRedirectUseCase(this._repository);

  Future<Either<Failure, GoogleAuthRedirect>> call() async {
    return await _repository.getGoogleAuthRedirect();
  }
}
