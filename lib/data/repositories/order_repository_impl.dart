import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/order_remote_data_source.dart';
import 'package:carfy/data/dtos/orders/checkout_request_dto.dart';
import 'package:carfy/data/mappers/order_mapper.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
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
        ),
      );
      return _mapper.mapCheckoutResult(res);
    });
  }
}
