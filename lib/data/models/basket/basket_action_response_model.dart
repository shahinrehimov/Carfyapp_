import 'package:carfy/data/models/basket/basket_data_model.dart';
import 'package:carfy/data/models/basket/basket_product_model.dart';

class BasketActionResponseModel {
  final String message;
  final BasketProductModel? product;
  final BasketDataModel basketData;

  BasketActionResponseModel({
    required this.message,
    this.product,
    required this.basketData,
  });

  factory BasketActionResponseModel.fromJson(Map<String, dynamic> json) {
    return BasketActionResponseModel(
      message: json['message'] as String,
      product: json['data'] != null ? BasketProductModel.fromJson(json['data'] as Map<String, dynamic>) : null,
      basketData: BasketDataModel.fromJson(json['basket_data'] as Map<String, dynamic>),
    );
  }
}
