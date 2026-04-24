import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();
}
