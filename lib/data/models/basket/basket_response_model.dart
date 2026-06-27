import 'package:carfy/data/models/basket/basket_data_model.dart';
import 'package:carfy/data/models/basket/basket_product_model.dart';

class BasketResponseModel {
  final List<BasketProductModel> items;
  final BasketDataModel basketData;

  BasketResponseModel({required this.items, required this.basketData});

  factory BasketResponseModel.fromJson(Map<String, dynamic> json) {
    return BasketResponseModel(
      items: (json['data'] as List<dynamic>)
          .map((item) => BasketProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      basketData: BasketDataModel.fromJson(json['basket_data'] as Map<String, dynamic>),
    );
  }
}
