import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/domain/repositories/payment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPaymentMethodsUseCase {
  final PaymentRepository _repository;

  GetPaymentMethodsUseCase(this._repository);

  Future<Either<Failure, List<PaymentMethod>>> call() => _repository.getPaymentMethods();
}
