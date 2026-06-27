import 'package:carfy/domain/entities/basket/basket_data.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';

class BasketActionResponse {
  final String message;
  final BasketProduct? product;
  final BasketData basketData;

  BasketActionResponse({required this.message, this.product, required this.basketData});
}
