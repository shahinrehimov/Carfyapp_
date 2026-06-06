class ReferralInfoModel {
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

  ReferralInfoModel({
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

  factory ReferralInfoModel.fromJson(Map<String, dynamic> json) {
    return ReferralInfoModel(
      code: json['code'] as String?,
      link: json['link'] as String?,
      tier: json['tier'] as String,
      rate: json['rate'] as String,
      isActive: json['is_active'] as bool,
      totalReferrals: json['total_referrals'] as int,
      activeReferrals: json['active_referrals'] as int,
      pendingReferrals: json['pending_referrals'] as int,
      pendingBalance: (json['pending_balance'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      lifetimeEarned: (json['lifetime_earned'] as num).toDouble(),
    );
  }
}
