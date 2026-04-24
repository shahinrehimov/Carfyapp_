import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/payment_remote_data_source.dart';
import 'package:carfy/data/mappers/payment_mapper.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/domain/repositories/payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl extends PaymentRepository with RepositorySafeCallMixin {
  final PaymentRemoteDataSource _dataSource;
  final PaymentMapper _mapper;

  PaymentRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() {
    return safeCall(() async {
      final res = await _dataSource.getPaymentMethods();
      return res.map(_mapper.mapPaymentMethod).toList();
    });
  }
}
