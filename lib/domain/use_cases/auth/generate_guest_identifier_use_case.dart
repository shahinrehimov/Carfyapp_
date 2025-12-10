import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../repositories/auth_repository.dart';

@injectable
class GenerateGuestIdentifierUseCase {
  final AuthRepository _repository;

  GenerateGuestIdentifierUseCase(this._repository);

  Future<Either<Failure, GuestIdentifierResponse>> call() async {
    return await _repository.generateGuestIdentifier();
  }
}
