import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/referral/referral_balance_model.dart';
import 'package:carfy/data/models/referral/referral_earning_model.dart';
import 'package:carfy/data/models/referral/referral_info_model.dart';
import 'package:carfy/data/models/referral/referral_perks_model.dart';
import 'package:carfy/data/models/referral/referral_user_model.dart';
import 'package:carfy/data/models/referral/referral_withdrawal_model.dart';
import 'package:injectable/injectable.dart';

abstract class ReferralRemoteDataSource {
  Future<ReferralInfoModel> getReferralInfo();
  Future<ReferralBalanceModel> getBalance();
  Future<String> updateCode(String code);
  Future<ReferralPerksModel> getPerks();
  Future<PaginationResponseModel<ReferralEarningModel>> loadEarnings({required int page, required int limit});
  Future<PaginationResponseModel<ReferralUserModel>> loadReferrals({required int page, required int limit});
  Future<PaginationResponseModel<ReferralWithdrawalModel>> loadWithdrawals({required int page, required int limit});
  Future<void> createWithdrawal({required double amount, required String cardLast4, required String cardHolderName});
}

@Injectable(as: ReferralRemoteDataSource)
class ReferralRemoteDataSourceImpl extends ReferralRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<ReferralInfoModel> getReferralInfo() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralMy),
      map: (json) => ReferralInfoModel.fromJson(json['data']),
    );
  }

  @override
  Future<String> updateCode(String code) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.referralUpdateCode, data: {'code': code}),
      map: (json) => json['data']['code'] as String,
    );
  }

  @override
  Future<ReferralPerksModel> getPerks() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralPerks),
      map: (json) => ReferralPerksModel.fromJson(json['data']),
    );
  }

  @override
  Future<PaginationResponseModel<ReferralEarningModel>> loadEarnings({required int page, required int limit}) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralEarnings, queryParams: {'page': page, 'limit': limit}),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => ReferralEarningModel.fromJson(item)),
    );
  }

  @override
  Future<PaginationResponseModel<ReferralUserModel>> loadReferrals({required int page, required int limit}) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralReferrals, queryParams: {'page': page, 'limit': limit}),
      map: (json) => PaginationResponseModel.fromFlatJson(json, (item) => ReferralUserModel.fromJson(item)),
    );
  }

  @override
  Future<PaginationResponseModel<ReferralWithdrawalModel>> loadWithdrawals({required int page, required int limit}) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralWithdrawals, queryParams: {'page': page, 'limit': limit}),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => ReferralWithdrawalModel.fromJson(item)),
    );
  }

  @override
  Future<void> createWithdrawal({required double amount, required String cardLast4, required String cardHolderName}) {
    return handleResponse(
      () => _networkManager.post(
        EndpointPaths.referralWithdrawals,
        data: {'amount': amount, 'card_last4': cardLast4, 'card_holder_name': cardHolderName},
      ),
      map: (_) {},
    );
  }

  @override
  Future<ReferralBalanceModel> getBalance() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.referralBalance),
      map: (json) => ReferralBalanceModel.fromJson(json['data']),
    );
  }
}
