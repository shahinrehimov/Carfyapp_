class CheckoutRequestDto {
  final String paymentMethod;
  final int addressId;
  final String? note;

  CheckoutRequestDto({
    required this.paymentMethod,
    required this.addressId,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'payment_method': paymentMethod,
        'address_id': addressId,
        if (note != null && note!.isNotEmpty) 'note': note,
      };
}
