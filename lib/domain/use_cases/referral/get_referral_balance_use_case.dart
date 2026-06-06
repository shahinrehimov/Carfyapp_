import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/referral/referral_balance.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReferralBalanceUseCase {
  final ReferralRepository _repository;

  GetReferralBalanceUseCase(this._repository);

  Future<Either<Failure, ReferralBalance>> call() => _repository.getBalance();
}
