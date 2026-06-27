import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/referral/referral_earning.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/entities/referral/referral_withdrawal.dart';
import 'package:carfy/domain/params/referral/referral_list_params.dart';
import 'package:carfy/domain/use_cases/referral/get_referral_info_use_case.dart';
import 'package:carfy/domain/use_cases/referral/get_referral_perks_use_case.dart';
import 'package:carfy/domain/use_cases/referral/load_referral_earnings_use_case.dart';
import 'package:carfy/domain/use_cases/referral/load_referral_users_use_case.dart';
import 'package:carfy/domain/use_cases/referral/load_referral_withdrawals_use_case.dart';
import 'package:carfy/domain/use_cases/referral/update_referral_code_use_case.dart';
import 'package:carfy/domain/use_cases/referral/create_withdrawal_use_case.dart';
import 'package:carfy/domain/params/referral/create_withdrawal_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../state/referral_state.dart';

class ReferralCubit extends Cubit<ReferralState> with StateMapHelper {
  final GetReferralInfoUseCase _getReferralInfoUseCase;
  final GetReferralPerksUseCase _getReferralPerksUseCase;
  final UpdateReferralCodeUseCase _updateReferralCodeUseCase;
  final CreateWithdrawalUseCase _createWithdrawalUseCase;
  final LoadReferralEarningsUseCase _loadEarningsUseCase;
  final LoadReferralUsersUseCase _loadReferralUsersUseCase;
  final LoadReferralWithdrawalsUseCase _loadWithdrawalsUseCase;

  final _earningsPagination = PaginationHelper();
  final _referralsPagination = PaginationHelper();
  final _withdrawalsPagination = PaginationHelper();

  ReferralCubit({
    GetReferralInfoUseCase? getReferralInfoUseCase,
    GetReferralPerksUseCase? getReferralPerksUseCase,
    UpdateReferralCodeUseCase? updateReferralCodeUseCase,
    CreateWithdrawalUseCase? createWithdrawalUseCase,
    LoadReferralEarningsUseCase? loadEarningsUseCase,
    LoadReferralUsersUseCase? loadReferralUsersUseCase,
    LoadReferralWithdrawalsUseCase? loadWithdrawalsUseCase,
  }) : _getReferralInfoUseCase = getReferralInfoUseCase ?? getIt<GetReferralInfoUseCase>(),
       _getReferralPerksUseCase = getReferralPerksUseCase ?? getIt<GetReferralPerksUseCase>(),
       _updateReferralCodeUseCase = updateReferralCodeUseCase ?? getIt<UpdateReferralCodeUseCase>(),
       _createWithdrawalUseCase = createWithdrawalUseCase ?? getIt<CreateWithdrawalUseCase>(),
       _loadEarningsUseCase = loadEarningsUseCase ?? getIt<LoadReferralEarningsUseCase>(),
       _loadReferralUsersUseCase = loadReferralUsersUseCase ?? getIt<LoadReferralUsersUseCase>(),
       _loadWithdrawalsUseCase = loadWithdrawalsUseCase ?? getIt<LoadReferralWithdrawalsUseCase>(),
       super(ReferralState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final results = await Future.wait([_getReferralInfoUseCase(), _getReferralPerksUseCase()]);

    final infoResult = results[0] as dynamic;
    final perksResult = results[1] as dynamic;

    ReferralInfo? info;
    ReferralPerks? perks;

    infoResult.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (data) => info = data);

    perksResult.fold((_) {}, (data) => perks = data);

    if (info != null) {
      emit(state.copyWith(status: StateStatus.success(), info: info, perks: perks));
    }
  }

  Future<void> loadEarnings() async {
    if (!_earningsPagination.shouldLoad()) return;
    emit(state.copyWith(earningsStatus: _earningsPagination.getLoadingStatus()));
    _earningsPagination.onLoadStart();
    final result = await _loadEarningsUseCase(ReferralListParams(page: _earningsPagination.currentPage));
    result.fold((failure) => emit(state.copyWith(earningsStatus: mapFailure(failure))), (response) {
      _earningsPagination.onLoadEnd(response.lastPage);
      emit(
        state.copyWith(
          earningsStatus: response.data.isEmpty && state.earnings.isEmpty ? StateStatus.empty() : StateStatus.success(),
          earnings: [...state.earnings, ...response.data],
        ),
      );
    });
  }

  Future<void> loadReferrals() async {
    if (!_referralsPagination.shouldLoad()) return;
    emit(state.copyWith(referralsStatus: _referralsPagination.getLoadingStatus()));
    _referralsPagination.onLoadStart();
    final result = await _loadReferralUsersUseCase(ReferralListParams(page: _referralsPagination.currentPage));
    result.fold((failure) => emit(state.copyWith(referralsStatus: mapFailure(failure))), (response) {
      _referralsPagination.onLoadEnd(response.lastPage);
      emit(
        state.copyWith(
          referralsStatus: response.data.isEmpty && state.referrals.isEmpty
              ? StateStatus.empty()
              : StateStatus.success(),
          referrals: [...state.referrals, ...response.data],
        ),
      );
    });
  }

  Future<void> loadWithdrawals() async {
    if (!_withdrawalsPagination.shouldLoad()) return;
    emit(state.copyWith(withdrawalsStatus: _withdrawalsPagination.getLoadingStatus()));
    _withdrawalsPagination.onLoadStart();
    final result = await _loadWithdrawalsUseCase(ReferralListParams(page: _withdrawalsPagination.currentPage));
    result.fold((failure) => emit(state.copyWith(withdrawalsStatus: mapFailure(failure))), (response) {
      _withdrawalsPagination.onLoadEnd(response.lastPage);
      emit(
        state.copyWith(
          withdrawalsStatus: response.data.isEmpty && state.withdrawals.isEmpty
              ? StateStatus.empty()
              : StateStatus.success(),
          withdrawals: [...state.withdrawals, ...response.data],
        ),
      );
    });
  }

  void setTabIndex(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }

  void loadMoreCurrentTab() {
    switch (state.currentTabIndex) {
      case 0:
        loadEarnings();
      case 1:
        loadReferrals();
      case 2:
        loadWithdrawals();
    }
  }

  Future<void> updateCode(String code) async {
    emit(state.copyWith(updateCodeStatus: StateStatus.loading()));
    final result = await _updateReferralCodeUseCase(code);
    result.fold((failure) => emit(state.copyWith(updateCodeStatus: mapFailure(failure))), (newCode) {
      final updatedInfo = state.info != null
          ? ReferralInfo(
              code: newCode,
              link: state.info!.link?.replaceAll(RegExp(r'ref=.*'), 'ref=$newCode'),
              tier: state.info!.tier,
              rate: state.info!.rate,
              isActive: state.info!.isActive,
              totalReferrals: state.info!.totalReferrals,
              activeReferrals: state.info!.activeReferrals,
              pendingReferrals: state.info!.pendingReferrals,
              pendingBalance: state.info!.pendingBalance,
              availableBalance: state.info!.availableBalance,
              lifetimeEarned: state.info!.lifetimeEarned,
            )
          : null;
      emit(state.copyWith(updateCodeStatus: StateStatus.successWithMessage(''), info: updatedInfo));
    });
  }

  Future<void> createWithdrawal({
    required double amount,
    required String cardLast4,
    required String cardHolderName,
  }) async {
    emit(state.copyWith(withdrawalCreateStatus: StateStatus.loading()));
    final result = await _createWithdrawalUseCase(
      CreateWithdrawalParams(amount: amount, cardLast4: cardLast4, cardHolderName: cardHolderName),
    );
    result.fold(
      (failure) => emit(state.copyWith(withdrawalCreateStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(withdrawalCreateStatus: StateStatus.successWithMessage(''))),
    );
  }
}
