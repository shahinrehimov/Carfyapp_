import 'package:carfy/common/data/mappers/pagination_mapper.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/order_remote_data_source.dart';
import 'package:carfy/data/dtos/orders/checkout_request_dto.dart';
import 'package:carfy/data/dtos/orders/orders_load_query_params.dart';
import 'package:carfy/data/mappers/order_mapper.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:carfy/domain/params/orders/check_payment_status_params.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
import 'package:carfy/domain/params/orders/orders_load_params.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderRepository)
class OrderRepositoryImpl extends OrderRepository with RepositorySafeCallMixin {
  final OrderRemoteDataSource _dataSource;
  final OrderMapper _mapper;

  OrderRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, CheckoutPreview>> getCheckoutPreview(int addressId) {
    return safeCall(() async {
      final res = await _dataSource.getCheckoutPreview(addressId);
      return _mapper.mapCheckoutPreview(res);
    });
  }

  @override
  Future<Either<Failure, CheckoutResult>> checkout(CheckoutParams params) {
    return safeCall(() async {
      final res = await _dataSource.checkout(
        CheckoutRequestDto(
          paymentMethod: params.paymentMethod,
          addressId: params.addressId,
          note: params.note,
          useReferralBalance: params.useReferralBalance,
        ),
      );
      return _mapper.mapCheckoutResult(res);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<OrderSummary>>> loadOrders(OrdersLoadParams params) {
    return safeCall(() async {
      final res = await _dataSource.loadOrders(
        OrdersLoadQueryParams(page: params.page, limit: params.limit),
      );
      return PaginationMapper.map(res, _mapper.mapOrderSummary);
    });
  }

  @override
  Future<Either<Failure, OrderDetail>> getOrderDetails(int id) {
    return safeCall(() async {
      final res = await _dataSource.getOrderDetails(id);
      return _mapper.mapOrderDetail(res);
    });
  }

  @override
  Future<Either<Failure, String>> checkPaymentStatus(CheckPaymentStatusParams params) {
    return safeCall(() async {
      return await _dataSource.checkPaymentStatus(params.orderUuid, params.paymentMethod, params.token);
    });
  }
}
