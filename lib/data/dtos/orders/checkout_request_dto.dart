class CheckoutRequestDto {
  final String paymentMethod;
  final int addressId;
  final String? note;
  final bool useReferralBalance;

  CheckoutRequestDto({
    required this.paymentMethod,
    required this.addressId,
    this.note,
    this.useReferralBalance = false,
  });

  Map<String, dynamic> toJson() => {
        'payment_method': paymentMethod,
        'address_id': addressId,
        if (note != null && note!.isNotEmpty) 'note': note,
        if (useReferralBalance) 'use_referral_balance': true,
      };
}
