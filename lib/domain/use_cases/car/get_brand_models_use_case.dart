import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBrandModelsUseCase {
  final CarRepository _repository;

  GetBrandModelsUseCase(this._repository);

  Future<Either<Failure, List<CarLibraryItem>>> call(int brandId) {
    return _repository.getBrandModels(brandId);
  }
}
