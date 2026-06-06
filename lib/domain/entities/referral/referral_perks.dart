class ReferralPerks {
  final bool hasPerks;
  final int freeDeliveryRemaining;
  final int discountOrdersRemaining;
  final String discountRate;

  ReferralPerks({
    required this.hasPerks,
    required this.freeDeliveryRemaining,
    required this.discountOrdersRemaining,
    required this.discountRate,
  });
}
