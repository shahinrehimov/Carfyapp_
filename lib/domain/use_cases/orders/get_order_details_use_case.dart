import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrderDetailsUseCase {
  final OrderRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<Either<Failure, OrderDetail>> call(int id) => _repository.getOrderDetails(id);
}
