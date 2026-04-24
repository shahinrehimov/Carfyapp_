import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBrandsUseCase {
  final CarRepository _repository;

  GetBrandsUseCase(this._repository);

  Future<Either<Failure, List<CarLibraryItem>>> call() {
    return _repository.getBrands();
  }
}
