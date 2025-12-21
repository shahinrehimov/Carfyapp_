import 'package:carfy/domain/entities/products/product.dart';

class BasketProduct {
  final Product product;
  final int basketQuantity;
  final double priceInBasket;
  final double priceFinalInBasket;

  BasketProduct({
    required this.product,
    required this.basketQuantity,
    required this.priceInBasket,
    required this.priceFinalInBasket,
  });
}
