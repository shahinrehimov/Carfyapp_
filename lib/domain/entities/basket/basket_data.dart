class BasketData {
  final double totalPriceInBasket;
  final double totalPriceFinalInBasket;
  final double totalDiscountInBasket;
  final double shipping;
  final int totalBasketQuantity;

  BasketData({
    required this.totalPriceInBasket,
    required this.totalPriceFinalInBasket,
    required this.totalDiscountInBasket,
    required this.shipping,
    required this.totalBasketQuantity,
  });
}