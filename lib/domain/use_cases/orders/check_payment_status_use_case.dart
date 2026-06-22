import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/params/orders/check_payment_status_params.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckPaymentStatusUseCase {
  final OrderRepository _repository;

  CheckPaymentStatusUseCase(this._repository);

  Future<Either<Failure, String>> call(CheckPaymentStatusParams params) =>
      _repository.checkPaymentStatus(params);
}
