class BasketDataModel {
  final double totalPrice;
  final double totalPriceFinal;
  final double totalDiscount;
  final double shipping;
  final int totalItems;

  BasketDataModel({
    required this.totalPrice,
    required this.totalPriceFinal,
    required this.totalDiscount,
    required this.shipping,
    required this.totalItems,
  });

  factory BasketDataModel.fromJson(Map<String, dynamic> json) {
    return BasketDataModel(
      totalPrice: ((json['total_price'] ?? json['total_price_in_basket']) as num).toDouble(),
      totalPriceFinal: ((json['total_price_final'] ?? json['total_price_final_in_basket']) as num).toDouble(),
      totalDiscount: ((json['total_discount'] ?? json['total_discount_in_basket']) as num).toDouble(),
      shipping: ((json['shipping'] ?? 0) as num).toDouble(),
      totalItems: (json['total_items'] ?? json['total_basket_quantity']) as int,
    );
  }
}
