import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/data/models/basket/basket_action_response_model.dart';
import 'package:carfy/data/models/basket/basket_data_model.dart';
import 'package:carfy/data/models/basket/basket_product_model.dart';
import 'package:carfy/data/models/basket/basket_quantity_response_model.dart';
import 'package:carfy/data/models/basket/basket_response_model.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/entities/basket/basket_data.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';
import 'package:carfy/domain/entities/basket/basket_quantity_response.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class BasketMapper {
  final ProductMapper _productMapper;

  BasketMapper(this._productMapper);

  BasketData mapBasketData(BasketDataModel model) => BasketData(
        totalPrice: model.totalPrice,
        totalPriceFinal: model.totalPriceFinal,
        totalDiscount: model.totalDiscount,
        shipping: model.shipping,
        totalItems: model.totalItems,
      );

  BasketProduct mapBasketProduct(BasketProductModel model) => BasketProduct(
        product: _productMapper.mapProduct(model.product),
        basketQuantity: model.basketQuantity,
        priceInBasket: model.priceInBasket,
        priceFinalInBasket: model.priceFinalInBasket,
      );

  BasketResponse mapBasketResponse(BasketResponseModel model) => BasketResponse(
        items: model.items.map(mapBasketProduct).toList(),
        basketData: mapBasketData(model.basketData),
      );

  BasketActionResponse mapBasketActionResponse(BasketActionResponseModel model) => BasketActionResponse(
        message: model.message,
        product: model.product != null ? mapBasketProduct(model.product!) : null,
        basketData: mapBasketData(model.basketData),
      );

  BasketQuantityResponse mapBasketQuantityResponse(BasketQuantityResponseModel model) => BasketQuantityResponse(
        message: model.message,
        quantity: model.quantity,
        basketData: mapBasketData(model.basketData),
      );
}
