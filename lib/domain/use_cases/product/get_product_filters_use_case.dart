import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/product_filters.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductFiltersUseCase {
  final ProductRepository _repository;

  GetProductFiltersUseCase(this._repository);

  Future<Either<Failure, ProductFilters>> call() async {
    return await _repository.getProductFilters();
  }
}
