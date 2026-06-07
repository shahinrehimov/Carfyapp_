class CheckoutParams {
  final String paymentMethod;
  final int addressId;
  final String? note;
  final bool useReferralBalance;

  CheckoutParams({
    required this.paymentMethod,
    required this.addressId,
    this.note,
    this.useReferralBalance = false,
  });
}
