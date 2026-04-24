import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:dartz/dartz.dart';

abstract class OrderRepository {
  Future<Either<Failure, CheckoutPreview>> getCheckoutPreview();
}
