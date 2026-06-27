class ProductOptionModel {
  final String optionName;
  final String optionLabel;
  final String value;

  ProductOptionModel({required this.optionName, required this.optionLabel, required this.value});

  factory ProductOptionModel.fromJson(Map<String, dynamic> json) {
    return ProductOptionModel(
      optionName: json['option_name'] as String,
      optionLabel: json['option_label'] as String,
      value: json['value'] as String,
    );
  }
}
