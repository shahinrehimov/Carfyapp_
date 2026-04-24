import 'package:carfy/domain/entities/basket/basket_data.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';

class BasketResponse {
  final List<BasketProduct> items;
  final BasketData basketData;

  BasketResponse({
    required this.items,
    required this.basketData,
  });
}