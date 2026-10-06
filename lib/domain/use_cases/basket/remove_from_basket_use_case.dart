import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_action_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveFromBasketUseCase {
  final BasketRepository _repository;

  RemoveFromBasketUseCase(this._repository);

  Future<Either<Failure, BasketActionResponse>> call(String cpvUuid, {int? brandId, int? brandModelId}) async {
    return await _repository.removeFromBasket(cpvUuid, brandId: brandId, brandModelId: brandModelId);
  }
}
