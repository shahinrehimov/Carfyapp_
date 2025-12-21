class BasketDataModel {
  final double totalPriceInBasket;
  final double totalPriceFinalInBasket;
  final double totalDiscountInBasket;
  final double shipping;
  final int totalBasketQuantity;

  BasketDataModel({
    required this.totalPriceInBasket,
    required this.totalPriceFinalInBasket,
    required this.totalDiscountInBasket,
    required this.shipping,
    required this.totalBasketQuantity,
  });

  factory BasketDataModel.fromJson(Map<String, dynamic> json) {
    return BasketDataModel(
      totalPriceInBasket: (json['total_price_in_basket'] as num).toDouble(),
      totalPriceFinalInBasket: (json['total_price_final_in_basket'] as num).toDouble(),
      totalDiscountInBasket: (json['total_discount_in_basket'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      totalBasketQuantity: json['total_basket_quantity'] as int,
    );
  }
}
