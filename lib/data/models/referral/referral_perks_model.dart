class ReferralPerksModel {
  final bool hasPerks;
  final int freeDeliveryRemaining;
  final int discountOrdersRemaining;
  final String discountRate;

  ReferralPerksModel({
    required this.hasPerks,
    required this.freeDeliveryRemaining,
    required this.discountOrdersRemaining,
    required this.discountRate,
  });

  factory ReferralPerksModel.fromJson(Map<String, dynamic> json) {
    return ReferralPerksModel(
      hasPerks: json['has_perks'] as bool,
      freeDeliveryRemaining: json['free_delivery_remaining'] as int,
      discountOrdersRemaining: json['discount_orders_remaining'] as int,
      discountRate: json['discount_rate'] as String,
    );
  }
}
