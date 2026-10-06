import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/entities/basket/basket_quantity_response.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:dartz/dartz.dart';

abstract class BasketRepository {
  Future<Either<Failure, BasketResponse>> getBasket();

  Future<Either<Failure, BasketActionResponse>> addToBasket(String cpvUuid, {int quantity = 1, int? brandId, int? brandModelId});

  Future<Either<Failure, BasketActionResponse>> removeFromBasket(String cpvUuid, {int? brandId, int? brandModelId});

  Future<Either<Failure, BasketQuantityResponse>> incrementQuantity(String cpvUuid, {int? brandId, int? brandModelId});

  Future<Either<Failure, BasketQuantityResponse>> decrementQuantity(String cpvUuid, {int? brandId, int? brandModelId});

  Future<Either<Failure, BasketActionResponse>> removeSetItem(String cpvUuid, int setItemId);

  Future<Either<Failure, BasketQuantityResponse>> incrementSetItem(String cpvUuid, int setItemId);

  Future<Either<Failure, BasketQuantityResponse>> decrementSetItem(String cpvUuid, int setItemId);
}
