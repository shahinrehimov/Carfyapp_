import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/params/product/product_show_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductShowUseCase {
  final ProductRepository _repository;

  GetProductShowUseCase(this._repository);

  Future<Either<Failure, ProductShow>> call(ProductShowParams params) {
    return _repository.getProductShow(params);
  }
}
