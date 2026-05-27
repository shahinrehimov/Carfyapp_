class OrderSummary {
  final int id;
  final String code;
  final String uuid;
  final int productsCount;
  final String status;
  final String statusLabel;
  final String date;

  OrderSummary({
    required this.id,
    required this.code,
    required this.uuid,
    required this.productsCount,
    required this.status,
    required this.statusLabel,
    required this.date,
  });
}
