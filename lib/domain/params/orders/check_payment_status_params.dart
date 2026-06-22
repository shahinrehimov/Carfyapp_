class CheckPaymentStatusParams {
  final String orderUuid;
  final String paymentMethod;
  final String token;

  CheckPaymentStatusParams({
    required this.orderUuid,
    required this.paymentMethod,
    required this.token,
  });
}
