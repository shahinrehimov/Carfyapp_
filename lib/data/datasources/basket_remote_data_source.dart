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
  Future<BasketActionResponseModel> addToBasket(String cpvUuid, {int quantity = 1, int? brandId, int? brandModelId});
  Future<BasketActionResponseModel> removeFromBasket(String cpvUuid, {int? brandId, int? brandModelId});
  Future<BasketQuantityResponseModel> incrementQuantity(String cpvUuid, {int? brandId, int? brandModelId});
  Future<BasketQuantityResponseModel> decrementQuantity(String cpvUuid, {int? brandId, int? brandModelId});
  Future<BasketActionResponseModel> removeSetItem(String cpvUuid, int setItemId);
  Future<BasketQuantityResponseModel> incrementSetItem(String cpvUuid, int setItemId);
  Future<BasketQuantityResponseModel> decrementSetItem(String cpvUuid, int setItemId);
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
  Future<BasketActionResponseModel> addToBasket(String cpvUuid, {int quantity = 1, int? brandId, int? brandModelId}) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketAdd(cpvUuid), data: {
        'quantity': quantity,
        if (brandId != null) 'brand_id': brandId,
        if (brandModelId != null) 'brand_model_id': brandModelId,
      }),
      map: (json) => BasketActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketActionResponseModel> removeFromBasket(String cpvUuid, {int? brandId, int? brandModelId}) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketRemove(cpvUuid), data: {
        if (brandId != null) 'brand_id': brandId,
        if (brandModelId != null) 'brand_model_id': brandModelId,
      }),
      map: (json) => BasketActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> incrementQuantity(String cpvUuid, {int? brandId, int? brandModelId}) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketIncrement(cpvUuid), data: {
        if (brandId != null) 'brand_id': brandId,
        if (brandModelId != null) 'brand_model_id': brandModelId,
      }),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> decrementQuantity(String cpvUuid, {int? brandId, int? brandModelId}) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketDecrement(cpvUuid), data: {
        if (brandId != null) 'brand_id': brandId,
        if (brandModelId != null) 'brand_model_id': brandModelId,
      }),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketActionResponseModel> removeSetItem(String cpvUuid, int setItemId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketRemoveSet(cpvUuid, setItemId)),
      map: (json) => BasketActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> incrementSetItem(String cpvUuid, int setItemId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketIncrementSet(cpvUuid, setItemId)),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }

  @override
  Future<BasketQuantityResponseModel> decrementSetItem(String cpvUuid, int setItemId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.basketDecrementSet(cpvUuid, setItemId)),
      map: (json) => BasketQuantityResponseModel.fromJson(json),
    );
  }
}
