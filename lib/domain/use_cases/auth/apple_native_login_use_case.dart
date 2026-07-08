import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/params/auth/apple_native_login_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:carfy/domain/use_cases/auth/save_auth_token_use_case.dart';
import 'package:carfy/domain/use_cases/auth/clear_guest_identifier_use_case.dart';

@injectable
class AppleNativeLoginUseCase {
  final AuthRepository _repository;
  final SaveAuthTokenUseCase _saveAuthTokenUseCase;
  final ClearGuestIdentifierUseCase _clearGuestIdentifierUseCase;

  AppleNativeLoginUseCase(this._repository, this._saveAuthTokenUseCase, this._clearGuestIdentifierUseCase);

  Future<Either<Failure, LoginResponse>> call() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    if (credential.identityToken == null) {
      return Left(UserFailure(message: 'Unable to retrieve identity token from Apple.'));
    }

    final result = await _repository.appleNativeLogin(
      params: AppleNativeLoginParams(
        identityToken: credential.identityToken!,
        authorizationCode: credential.authorizationCode,
        name: credential.givenName,
        surname: credential.familyName,
      ),
    );

    await result.fold((_) async {}, (success) async {
      await _saveAuthTokenUseCase(success.token);
      await _clearGuestIdentifierUseCase();
    });

    return result;
  }
}
