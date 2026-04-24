class PaymentMethod {
  final String value;
  final String label;
  final List<String> requiredFields;

  PaymentMethod({
    required this.value,
    required this.label,
    required this.requiredFields,
  });
}
