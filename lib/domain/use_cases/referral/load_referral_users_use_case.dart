import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/params/referral/referral_list_params.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadReferralUsersUseCase {
  final ReferralRepository _repository;

  LoadReferralUsersUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<ReferralUser>>> call(ReferralListParams params) =>
      _repository.loadReferrals(params);
}
