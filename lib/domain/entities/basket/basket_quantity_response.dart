import 'package:carfy/domain/entities/basket/basket_data.dart';

class BasketQuantityResponse {
  final String message;
  final int quantity;
  final BasketData basketData;

  BasketQuantityResponse({
    required this.message,
    required this.quantity,
    required this.basketData,
  });
}
