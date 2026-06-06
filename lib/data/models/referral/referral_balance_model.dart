class ReferralBalanceModel {
  final double pendingBalance;
  final double availableBalance;
  final double lifetimeEarned;
  final double lifetimeWithdrawn;
  final double lifetimeSpentOnPlatform;

  ReferralBalanceModel({
    required this.pendingBalance,
    required this.availableBalance,
    required this.lifetimeEarned,
    required this.lifetimeWithdrawn,
    required this.lifetimeSpentOnPlatform,
  });

  factory ReferralBalanceModel.fromJson(Map<String, dynamic> json) {
    return ReferralBalanceModel(
      pendingBalance: (json['pending_balance'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      lifetimeEarned: (json['lifetime_earned'] as num).toDouble(),
      lifetimeWithdrawn: (json['lifetime_withdrawn'] as num).toDouble(),
      lifetimeSpentOnPlatform: (json['lifetime_spent_on_platform'] as num).toDouble(),
    );
  }
}
