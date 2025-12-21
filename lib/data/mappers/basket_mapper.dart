import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/data/models/basket/basket_data_model.dart';
import 'package:carfy/data/models/basket/basket_product_model.dart';
import 'package:carfy/data/models/basket/basket_response_model.dart';
import 'package:carfy/domain/entities/basket/basket_data.dart';
import 'package:carfy/domain/entities/basket/basket_product.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class BasketMapper {
  final ProductMapper _productMapper;

  BasketMapper(this._productMapper);

  BasketData mapBasketData(BasketDataModel model) => BasketData(
        totalPriceInBasket: model.totalPriceInBasket,
        totalPriceFinalInBasket: model.totalPriceFinalInBasket,
        totalDiscountInBasket: model.totalDiscountInBasket,
        shipping: model.shipping,
        totalBasketQuantity: model.totalBasketQuantity,
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
}
