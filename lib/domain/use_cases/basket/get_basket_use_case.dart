import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBasketUseCase {
  final BasketRepository _repository;

  GetBasketUseCase(this._repository);

  Future<Either<Failure, BasketResponse>> call() async {
    return await _repository.getBasket();
  }
}
