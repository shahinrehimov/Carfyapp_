import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutUseCase {
  final OrderRepository _repository;

  CheckoutUseCase(this._repository);

  Future<Either<Failure, CheckoutResult>> call(CheckoutParams params) => _repository.checkout(params);
}
