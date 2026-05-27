class OrderSummaryModel {
  final int id;
  final String code;
  final String uuid;
  final int productsCount;
  final String status;
  final String statusLabel;
  final String date;

  OrderSummaryModel({
    required this.id,
    required this.code,
    required this.uuid,
    required this.productsCount,
    required this.status,
    required this.statusLabel,
    required this.date,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] as int,
      code: json['code'] as String,
      uuid: json['uuid'] as String,
      productsCount: json['products_count'] as int,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      date: json['date'] as String,
    );
  }
}
