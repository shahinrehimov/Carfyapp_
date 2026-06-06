import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReferralInfoUseCase {
  final ReferralRepository _repository;

  GetReferralInfoUseCase(this._repository);

  Future<Either<Failure, ReferralInfo>> call() => _repository.getReferralInfo();
}
