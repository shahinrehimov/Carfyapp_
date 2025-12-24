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
  Future<Either<Failure, BasketActionResponse>> addToBasket(int productId, {int quantity = 1}) {
    return safeCall(() async {
      final res = await _remoteDataSource.addToBasket(productId, quantity: quantity);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketActionResponse>> removeFromBasket(int productId) {
    return safeCall(() async {
      final res = await _remoteDataSource.removeFromBasket(productId);
      return _mapper.mapBasketActionResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> incrementQuantity(int productId) {
    return safeCall(() async {
      final res = await _remoteDataSource.incrementQuantity(productId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }

  @override
  Future<Either<Failure, BasketQuantityResponse>> decrementQuantity(int productId) {
    return safeCall(() async {
      final res = await _remoteDataSource.decrementQuantity(productId);
      return _mapper.mapBasketQuantityResponse(res);
    });
  }
}
