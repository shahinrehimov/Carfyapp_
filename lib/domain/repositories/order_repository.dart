import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
import 'package:dartz/dartz.dart';

abstract class OrderRepository {
  Future<Either<Failure, CheckoutPreview>> getCheckoutPreview(int addressId);
  Future<Either<Failure, CheckoutResult>> checkout(CheckoutParams params);
}
