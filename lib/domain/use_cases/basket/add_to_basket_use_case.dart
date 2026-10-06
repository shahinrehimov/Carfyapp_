import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToBasketUseCase {
  final BasketRepository _repository;

  AddToBasketUseCase(this._repository);

  Future<Either<Failure, BasketActionResponse>> call(String cpvUuid, {int quantity = 1, int? brandId, int? brandModelId}) async {
    return await _repository.addToBasket(cpvUuid, quantity: quantity, brandId: brandId, brandModelId: brandModelId);
  }
}
