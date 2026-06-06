class ReferralEarning {
  final int id;
  final double amount;
  final double orderAmount;
  final String rate;
  final String tier;
  final String status;
  final String orderUuid;
  final String? deliveredAt;
  final String? availableAt;
  final String? creditedAt;

  ReferralEarning({
    required this.id,
    required this.amount,
    required this.orderAmount,
    required this.rate,
    required this.tier,
    required this.status,
    required this.orderUuid,
    this.deliveredAt,
    this.availableAt,
    this.creditedAt,
  });
}
