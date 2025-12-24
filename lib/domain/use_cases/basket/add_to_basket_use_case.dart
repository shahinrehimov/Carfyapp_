import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToBasketUseCase {
  final BasketRepository _repository;

  AddToBasketUseCase(this._repository);

  Future<Either<Failure, BasketActionResponse>> call(int productId, {int quantity = 1}) async {
    return await _repository.addToBasket(productId, quantity: quantity);
  }
}
