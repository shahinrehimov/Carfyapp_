import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/order_remote_data_source.dart';
import 'package:carfy/data/mappers/order_mapper.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderRepository)
class OrderRepositoryImpl extends OrderRepository with RepositorySafeCallMixin {
  final OrderRemoteDataSource _dataSource;
  final OrderMapper _mapper;

  OrderRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, CheckoutPreview>> getCheckoutPreview() {
    return safeCall(() async {
      final res = await _dataSource.getCheckoutPreview();
      return _mapper.mapCheckoutPreview(res);
    });
  }
}
