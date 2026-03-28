class YearRangeModel {
  final int min;
  final int max;

  YearRangeModel({
    required this.min,
    required this.max,
  });

  factory YearRangeModel.fromJson(Map<String, dynamic> json) {
    return YearRangeModel(
      min: json['min'] as int,
      max: json['max'] as int,
    );
  }
}
