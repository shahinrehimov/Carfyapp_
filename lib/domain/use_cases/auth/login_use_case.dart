import 'package:carfy/common/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../entities/auth/auth_session.dart';
import '../../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, AuthSession>> call({required String username, required String password}) async {
    return await _authRepository.login(username: username, password: password);
  }
}
