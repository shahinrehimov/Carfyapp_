class CheckoutParams {
  final String paymentMethod;
  final int addressId;
  final String? note;

  CheckoutParams({
    required this.paymentMethod,
    required this.addressId,
    this.note,
  });
}
