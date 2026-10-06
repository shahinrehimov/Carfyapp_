import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/basket_remote_data_source.dart';
import 'package:carfy/data/mappers/basket_mapper.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/entities/basket/basket_quantity_response.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BasketRepository)
class BasketRepositoryImpl extends BasketRepository with RepositorySafeCallMixin {
  final BasketRemoteDataSource _remoteDataSource;
  final BasketMapper _mapper;

  BasketRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, BasketResponse>> getBasket() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchBasket();
      return _mapper.mapBasketResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketActionResponse>> addToBasket(String cpvUuid, {int quantity = 1, int? brandId, int? brandModelId}) {
    return safeCall(() async {
      final res = await _remoteDataSource.addToBasket(cpvUuid, quantity: quantity, brandId: brandId, brandModelId: brandModelId);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketActionResponse>> removeFromBasket(String cpvUuid, {int? brandId, int? brandModelId}) {
    return safeCall(() async {
      final res = await _remoteDataSource.removeFromBasket(cpvUuid, brandId: brandId, brandModelId: brandModelId);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> incrementQuantity(String cpvUuid, {int? brandId, int? brandModelId}) {
    return safeCall(() async {
      final res = await _remoteDataSource.incrementQuantity(cpvUuid, brandId: brandId, brandModelId: brandModelId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> decrementQuantity(String cpvUuid, {int? brandId, int? brandModelId}) {
    return safeCall(() async {
      final res = await _remoteDataSource.decrementQuantity(cpvUuid, brandId: brandId, brandModelId: brandModelId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketActionResponse>> removeSetItem(String cpvUuid, int setItemId) {
    return safeCall(() async {
      final res = await _remoteDataSource.removeSetItem(cpvUuid, setItemId);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> incrementSetItem(String cpvUuid, int setItemId) {
    return safeCall(() async {
      final res = await _remoteDataSource.incrementSetItem(cpvUuid, setItemId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> decrementSetItem(String cpvUuid, int setItemId) {
    return safeCall(() async {
      final res = await _remoteDataSource.decrementSetItem(cpvUuid, setItemId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }
}
