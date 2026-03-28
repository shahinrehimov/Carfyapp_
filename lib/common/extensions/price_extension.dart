extension PriceExtension on double {
  static const _usdToAzn = 1.7;

  double get toManat => this * _usdToAzn;

  String get manatFormatted => '${toManat.toStringAsFixed(2)} ₼';
}
