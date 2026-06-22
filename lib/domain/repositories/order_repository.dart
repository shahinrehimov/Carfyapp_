import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:carfy/domain/params/orders/check_payment_status_params.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
import 'package:carfy/domain/params/orders/orders_load_params.dart';
import 'package:dartz/dartz.dart';

abstract class OrderRepository {
  Future<Either<Failure, CheckoutPreview>> getCheckoutPreview(int addressId);
  Future<Either<Failure, CheckoutResult>> checkout(CheckoutParams params);
  Future<Either<Failure, PaginationResponse<OrderSummary>>> loadOrders(OrdersLoadParams params);
  Future<Either<Failure, OrderDetail>> getOrderDetails(int id);
  Future<Either<Failure, String>> checkPaymentStatus(CheckPaymentStatusParams params);
}
