import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_quantity_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncrementQuantityUseCase {
  final BasketRepository _repository;

  IncrementQuantityUseCase(this._repository);

  Future<Either<Failure, BasketQuantityResponse>> call(int productId) async {
    return await _repository.incrementQuantity(productId);
  }
}
