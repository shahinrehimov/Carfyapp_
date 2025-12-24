import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/basket/basket_action_response_model.dart';
import 'package:carfy/data/models/basket/basket_quantity_response_model.dart';
import 'package:carfy/data/models/basket/basket_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class BasketRemoteDataSource {
  Future<BasketResponseModel> fetchBasket();
  Future<BasketActionResponseModel> addToBasket(int productId, {int quantity = 1});
  Future<BasketActionResponseModel> removeFromBasket(int productId);
  Future<BasketQuantityResponseModel> incrementQuantity(int productId);
  Future<BasketQuantityResponseModel> decrementQuantity(int productId);
}

@Injectable(as: BasketRemoteDataSource)
class BasketRemoteDataSourceImpl extends BasketRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<BasketResponseModel> fetchBasket() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.basketLoad),
      map: (json) => BasketResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketActionResponseModel> addToBasket(int productId, {int quantity = 1}) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketAdd(productId), data: {'quantity': quantity}),
      map: (json) => BasketActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketActionResponseModel> removeFromBasket(int productId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketRemove(productId)),
      map: (json) => BasketActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> incrementQuantity(int productId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketIncrement(productId)),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> decrementQuantity(int productId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketDecrement(productId)),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }
}
