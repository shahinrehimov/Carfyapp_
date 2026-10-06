import 'package:carfy/domain/entities/basket/fitment_selection.dart';
import 'package:carfy/domain/entities/products/product.dart';

class BasketProduct {
  final Product product;
  final int basketQuantity;
  final double priceInBasket;
  final double priceFinalInBasket;
  final FitmentSelection? fitmentSelection;

  BasketProduct({
    required this.product,
    required this.basketQuantity,
    required this.priceInBasket,
    required this.priceFinalInBasket,
    this.fitmentSelection,
  });

  /// Unique key for this basket row: same product can appear for different fitments.
  String get itemKey {
    final cpvUuid = product.seller?.uuid ?? product.uuid;
    final brandId = fitmentSelection?.brand?.id;
    final modelId = fitmentSelection?.brandModel?.id;
    return '$cpvUuid:$brandId:$modelId';
  }
}
