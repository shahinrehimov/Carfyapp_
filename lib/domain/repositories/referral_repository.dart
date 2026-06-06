import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/referral/referral_balance.dart';
import 'package:carfy/domain/entities/referral/referral_earning.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/entities/referral/referral_withdrawal.dart';
import 'package:carfy/domain/params/referral/create_withdrawal_params.dart';
import 'package:carfy/domain/params/referral/referral_list_params.dart';
import 'package:dartz/dartz.dart';

abstract class ReferralRepository {
  Future<Either<Failure, ReferralInfo>> getReferralInfo();
  Future<Either<Failure, ReferralBalance>> getBalance();
  Future<Either<Failure, String>> updateCode(String code);
  Future<Either<Failure, ReferralPerks>> getPerks();
  Future<Either<Failure, PaginationResponse<ReferralEarning>>> loadEarnings(ReferralListParams params);
  Future<Either<Failure, PaginationResponse<ReferralUser>>> loadReferrals(ReferralListParams params);
  Future<Either<Failure, PaginationResponse<ReferralWithdrawal>>> loadWithdrawals(ReferralListParams params);
  Future<Either<Failure, void>> createWithdrawal(CreateWithdrawalParams params);
}
