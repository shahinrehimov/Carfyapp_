class ReferralEarningModel {
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

  ReferralEarningModel({
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

  factory ReferralEarningModel.fromJson(Map<String, dynamic> json) {
    return ReferralEarningModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      orderAmount: (json['order_amount'] as num).toDouble(),
      rate: json['rate'] as String,
      tier: json['tier'] as String,
      status: json['status'] as String,
      orderUuid: json['order_uuid'] as String,
      deliveredAt: json['delivered_at'] as String?,
      availableAt: json['available_at'] as String?,
      creditedAt: json['credited_at'] as String?,
    );
  }
}
