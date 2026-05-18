import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCheckoutPreviewUseCase {
  final OrderRepository _repository;

  GetCheckoutPreviewUseCase(this._repository);

  Future<Either<Failure, CheckoutPreview>> call(int addressId) => _repository.getCheckoutPreview(addressId);
}
