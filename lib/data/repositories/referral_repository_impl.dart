import 'package:carfy/common/data/mappers/pagination_mapper.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/referral_remote_data_source.dart';
import 'package:carfy/data/mappers/referral_mapper.dart';
import 'package:carfy/domain/entities/referral/referral_balance.dart';
import 'package:carfy/domain/entities/referral/referral_earning.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/entities/referral/referral_withdrawal.dart';
import 'package:carfy/domain/params/referral/create_withdrawal_params.dart';
import 'package:carfy/domain/params/referral/referral_list_params.dart';
import 'package:carfy/domain/repositories/referral_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ReferralRepository)
class ReferralRepositoryImpl extends ReferralRepository with RepositorySafeCallMixin {
  final ReferralRemoteDataSource _dataSource;
  final ReferralMapper _mapper;

  ReferralRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, ReferralInfo>> getReferralInfo() {
    return safeCall(() async {
      final res = await _dataSource.getReferralInfo();
      return _mapper.mapInfo(res);
    });
  }

  @override
  Future<Either<Failure, ReferralBalance>> getBalance() {
    return safeCall(() async {
      final res = await _dataSource.getBalance();
      return _mapper.mapBalance(res);
    });
  }

  @override
  Future<Either<Failure, String>> updateCode(String code) {
    return safeCall(() => _dataSource.updateCode(code));
  }

  @override
  Future<Either<Failure, ReferralPerks>> getPerks() {
    return safeCall(() async {
      final res = await _dataSource.getPerks();
      return _mapper.mapPerks(res);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<ReferralEarning>>> loadEarnings(ReferralListParams params) {
    return safeCall(() async {
      final res = await _dataSource.loadEarnings(page: params.page, limit: params.limit);
      return PaginationMapper.map(res, _mapper.mapEarning);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<ReferralUser>>> loadReferrals(ReferralListParams params) {
    return safeCall(() async {
      final res = await _dataSource.loadReferrals(page: params.page, limit: params.limit);
      return PaginationMapper.map(res, _mapper.mapReferralUser);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<ReferralWithdrawal>>> loadWithdrawals(ReferralListParams params) {
    return safeCall(() async {
      final res = await _dataSource.loadWithdrawals(page: params.page, limit: params.limit);
      return PaginationMapper.map(res, _mapper.mapWithdrawal);
    });
  }

  @override
  Future<Either<Failure, void>> createWithdrawal(CreateWithdrawalParams params) {
    return safeCall(
      () => _dataSource.createWithdrawal(
        amount: params.amount,
        cardLast4: params.cardLast4,
        cardHolderName: params.cardHolderName,
      ),
    );
  }
}
