import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:carfy/domain/params/orders/orders_load_params.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadOrdersUseCase {
  final OrderRepository _repository;

  LoadOrdersUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<OrderSummary>>> call(OrdersLoadParams params) =>
      _repository.loadOrders(params);
}
