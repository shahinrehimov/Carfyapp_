import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:carfy/domain/use_cases/auth/save_guest_identifier_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class GenerateGuestIdentifierUseCase {
  final AuthRepository _repository;
  final SaveGuestIdentifierUseCase _saveGuestIdentifierUseCase;

  GenerateGuestIdentifierUseCase(this._repository, this._saveGuestIdentifierUseCase);

  Future<Either<Failure, GuestIdentifierResponse>> call() async {
    final result = await _repository.generateGuestIdentifier();
    await result.fold((_) async {}, (success) async {
      await _saveGuestIdentifierUseCase(success.identifier);
    });
    return result;
  }
}
