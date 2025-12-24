import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/entities/basket/basket_quantity_response.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:dartz/dartz.dart';

abstract class BasketRepository {
  Future<Either<Failure, BasketResponse>> getBasket();

  Future<Either<Failure, BasketActionResponse>> addToBasket(int productId, {int quantity = 1});

  Future<Either<Failure, BasketActionResponse>> removeFromBasket(int productId);

  Future<Either<Failure, BasketQuantityResponse>> incrementQuantity(int productId);

  Future<Either<Failure, BasketQuantityResponse>> decrementQuantity(int productId);
}
