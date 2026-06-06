class ReferralInfo {
  final String? code;
  final String? link;
  final String tier;
  final String rate;
  final bool isActive;
  final int totalReferrals;
  final int activeReferrals;
  final int pendingReferrals;
  final double pendingBalance;
  final double availableBalance;
  final double lifetimeEarned;

  ReferralInfo({
    required this.code,
    required this.link,
    required this.tier,
    required this.rate,
    required this.isActive,
    required this.totalReferrals,
    required this.activeReferrals,
    required this.pendingReferrals,
    required this.pendingBalance,
    required this.availableBalance,
    required this.lifetimeEarned,
  });
}
