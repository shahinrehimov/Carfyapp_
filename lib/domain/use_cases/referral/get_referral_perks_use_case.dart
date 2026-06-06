import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReferralPerksUseCase {
  final ReferralRepository _repository;

  GetReferralPerksUseCase(this._repository);

  Future<Either<Failure, ReferralPerks>> call() => _repository.getPerks();
}
