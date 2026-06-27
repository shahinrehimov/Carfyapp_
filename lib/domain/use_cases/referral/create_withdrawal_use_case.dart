import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/params/referral/create_withdrawal_params.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateWithdrawalUseCase {
  final ReferralRepository _repository;

  CreateWithdrawalUseCase(this._repository);

  Future<Either<Failure, void>> call(CreateWithdrawalParams params) => _repository.createWithdrawal(params);
}
