import 'package:carfy/data/models/basket/fitment_selection_model.dart';
import 'package:carfy/data/models/product/product_model.dart';

class BasketProductModel {
  final ProductModel product;
  final int basketQuantity;
  final double priceInBasket;
  final double priceFinalInBasket;
  final FitmentSelectionModel? fitmentSelection;

  BasketProductModel({
    required this.product,
    required this.basketQuantity,
    required this.priceInBasket,
    required this.priceFinalInBasket,
    this.fitmentSelection,
  });

  factory BasketProductModel.fromJson(Map<String, dynamic> json) {
    return BasketProductModel(
      product: ProductModel.fromJson(json),
      basketQuantity: json['basket_quantity'] as int,
      priceInBasket: (json['price_in_basket'] as num).toDouble(),
      priceFinalInBasket: (json['price_final_in_basket'] as num).toDouble(),
      fitmentSelection: json['fitment_selection'] != null
          ? FitmentSelectionModel.fromJson(json['fitment_selection'] as Map<String, dynamic>)
          : null,
    );
  }
}
