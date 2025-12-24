import 'package:carfy/data/models/basket/basket_data_model.dart';

class BasketQuantityResponseModel {
  final String message;
  final int quantity;
  final BasketDataModel basketData;

  BasketQuantityResponseModel({
    required this.message,
    required this.quantity,
    required this.basketData,
  });

  factory BasketQuantityResponseModel.fromJson(Map<String, dynamic> json) {
    return BasketQuantityResponseModel(
      message: json['message'] as String,
      quantity: json['quantity'] as int,
      basketData: BasketDataModel.fromJson(json['basket_data'] as Map<String, dynamic>),
    );
  }
}
