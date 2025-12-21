import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:dartz/dartz.dart';

abstract class BasketRepository {
  Future<Either<Failure, BasketResponse>> getBasket();
}
