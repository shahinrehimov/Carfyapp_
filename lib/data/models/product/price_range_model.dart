class PriceRangeModel {
  final double min;
  final double max;

  PriceRangeModel({
    required this.min,
    required this.max,
  });

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );
  }
}
