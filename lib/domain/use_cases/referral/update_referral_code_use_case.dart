import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateReferralCodeUseCase {
  final ReferralRepository _repository;

  UpdateReferralCodeUseCase(this._repository);

  Future<Either<Failure, String>> call(String code) => _repository.updateCode(code);
}
