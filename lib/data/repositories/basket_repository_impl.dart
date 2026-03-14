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
  Future<Either<Failure, BasketActionResponse>> addToBasket(String cpvUuid, {int quantity = 1}) {
    return safeCall(() async {
      final res = await _remoteDataSource.addToBasket(cpvUuid, quantity: quantity);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketActionResponse>> removeFromBasket(String cpvUuid) {
    return safeCall(() async {
      final res = await _remoteDataSource.removeFromBasket(cpvUuid);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> incrementQuantity(String cpvUuid) {
    return safeCall(() async {
      final res = await _remoteDataSource.incrementQuantity(cpvUuid);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> decrementQuantity(String cpvUuid) {
    return safeCall(() async {
      final res = await _remoteDataSource.decrementQuantity(cpvUuid);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }
}
