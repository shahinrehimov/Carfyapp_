import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFuelTypesUseCase {
  final CarRepository _repository;

  GetFuelTypesUseCase(this._repository);

  Future<Either<Failure, List<CarLibraryItem>>> call() {
    return _repository.getFuelTypes();
  }
}
