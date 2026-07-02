import 'package:carfy/domain/use_cases/auth/clear_guest_identifier_use_case.dart';
import 'package:carfy/domain/use_cases/auth/save_auth_token_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/params/auth/login_with_email_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class LoginWithEmailUseCase {
  final AuthRepository _repository;
  final SaveAuthTokenUseCase _saveAuthTokenUseCase;
  final ClearGuestIdentifierUseCase _clearGuestIdentifierUseCase;

  LoginWithEmailUseCase(this._repository, this._saveAuthTokenUseCase, this._clearGuestIdentifierUseCase);

  Future<Either<Failure, LoginResponse>> call(LoginWithEmailParams params) async {
    final result = await _repository.loginWithEmail(params: params);
    await result.fold((_) async {}, (success) async {
      await _saveAuthTokenUseCase(success.token);
      await _clearGuestIdentifierUseCase();
    });
    return result;
  }
}
