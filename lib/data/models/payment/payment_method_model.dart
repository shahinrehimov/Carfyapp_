class PaymentMethodModel {
  final String value;
  final String label;
  final List<String> requiredFields;

  PaymentMethodModel({required this.value, required this.label, required this.requiredFields});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      value: json['value'] as String,
      label: json['label'] as String,
      requiredFields: ((json['required_fields'] as List<dynamic>?) ?? const []).map((e) => e as String).toList(),
    );
  }
}
