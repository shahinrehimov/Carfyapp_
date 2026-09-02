import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/logout_response.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:carfy/domain/use_cases/auth/clear_auth_token_use_case.dart';
import 'package:carfy/domain/use_cases/auth/clear_guest_identifier_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAccountUseCase {
  final AuthRepository _repository;
  final ClearAuthTokenUseCase _clearAuthTokenUseCase;
  final ClearGuestIdentifierUseCase _clearGuestIdentifierUseCase;

  DeleteAccountUseCase(this._repository, this._clearAuthTokenUseCase, this._clearGuestIdentifierUseCase);

  Future<Either<Failure, LogoutResponse>> call() async {
    final result = await _repository.deleteAccount();
    await _clearAuthTokenUseCase();
    await _clearGuestIdentifierUseCase();
    return result;
  }
}
