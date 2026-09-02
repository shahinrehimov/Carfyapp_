import 'dart:io';

import 'package:carfy/common/constants/constants.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/params/auth/google_native_login_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:carfy/domain/use_cases/auth/clear_guest_identifier_use_case.dart';
import 'package:carfy/domain/use_cases/auth/save_auth_token_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoogleNativeLoginUseCase {
  final AuthRepository _repository;
  final SaveAuthTokenUseCase _saveAuthTokenUseCase;
  final ClearGuestIdentifierUseCase _clearGuestIdentifierUseCase;

  GoogleNativeLoginUseCase(this._repository, this._saveAuthTokenUseCase, this._clearGuestIdentifierUseCase);

  Future<Either<Failure, LoginResponse>> call() async {
    final googleSignIn = GoogleSignIn(
      serverClientId: Constants.googleSignInServerClientId,
      scopes: ['email', 'profile'],
    );

    await googleSignIn.signOut();
    final account = await googleSignIn.signIn();

    if (account == null) return Left(UserFailure(message: 'Google sign in was cancelled.'));

    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (idToken == null) return Left(UserFailure(message: 'Unable to retrieve id token from Google.'));

    final result = await _repository.googleNativeLogin(
      params: GoogleNativeLoginParams(
        idToken: idToken,
        deviceType: Platform.isIOS ? 'ios' : 'android',
      ),
    );

    await result.fold((_) async {}, (success) async {
      await _saveAuthTokenUseCase(success.token);
      await _clearGuestIdentifierUseCase();
    });

    return result;
  }
}
