part of 'referral_cubit.dart';

class ReferralState extends Equatable {
  final StateStatus status;
  final StateStatus updateCodeStatus;
  final StateStatus withdrawalCreateStatus;
  final StateStatus earningsStatus;
  final StateStatus referralsStatus;
  final StateStatus withdrawalsStatus;
  final ReferralInfo? info;
  final ReferralPerks? perks;
  final List<ReferralEarning> earnings;
  final List<ReferralUser> referrals;
  final List<ReferralWithdrawal> withdrawals;

  const ReferralState({
    required this.status,
    required this.updateCodeStatus,
    required this.withdrawalCreateStatus,
    required this.earningsStatus,
    required this.referralsStatus,
    required this.withdrawalsStatus,
    this.info,
    this.perks,
    required this.earnings,
    required this.referrals,
    required this.withdrawals,
  });

  factory ReferralState.initial() => ReferralState(
        status: StateStatus.loading(),
        updateCodeStatus: StateStatus.initial(),
        withdrawalCreateStatus: StateStatus.initial(),
        earningsStatus: StateStatus.initial(),
        referralsStatus: StateStatus.initial(),
        withdrawalsStatus: StateStatus.initial(),
        earnings: const [],
        referrals: const [],
        withdrawals: const [],
      );

  ReferralState copyWith({
    StateStatus? status,
    StateStatus? updateCodeStatus,
    StateStatus? withdrawalCreateStatus,
    StateStatus? earningsStatus,
    StateStatus? referralsStatus,
    StateStatus? withdrawalsStatus,
    ReferralInfo? info,
    ReferralPerks? perks,
    List<ReferralEarning>? earnings,
    List<ReferralUser>? referrals,
    List<ReferralWithdrawal>? withdrawals,
  }) {
    return ReferralState(
      status: status ?? this.status,
      updateCodeStatus: updateCodeStatus ?? this.updateCodeStatus,
      withdrawalCreateStatus: withdrawalCreateStatus ?? this.withdrawalCreateStatus,
      earningsStatus: earningsStatus ?? this.earningsStatus,
      referralsStatus: referralsStatus ?? this.referralsStatus,
      withdrawalsStatus: withdrawalsStatus ?? this.withdrawalsStatus,
      info: info ?? this.info,
      perks: perks ?? this.perks,
      earnings: earnings ?? this.earnings,
      referrals: referrals ?? this.referrals,
      withdrawals: withdrawals ?? this.withdrawals,
    );
  }

  @override
  List<Object?> get props => [
        status,
        updateCodeStatus,
        withdrawalCreateStatus,
        earningsStatus,
        referralsStatus,
        withdrawalsStatus,
        info,
        perks,
        earnings,
        referrals,
        withdrawals,
      ];
}
