import 'package:carfy/data/models/product/product_model.dart';

class BasketProductModel {
  final ProductModel product;
  final int basketQuantity;
  final double priceInBasket;
  final double priceFinalInBasket;

  BasketProductModel({
    required this.product,
    required this.basketQuantity,
    required this.priceInBasket,
    required this.priceFinalInBasket,
  });

  factory BasketProductModel.fromJson(Map<String, dynamic> json) {
    return BasketProductModel(
      product: ProductModel.fromJson(json),
      basketQuantity: json['basket_quantity'] as int,
      priceInBasket: (json['price_in_basket'] as num).toDouble(),
      priceFinalInBasket: (json['price_final_in_basket'] as num).toDouble(),
    );
  }
}
