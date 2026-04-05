import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/car_color.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCarColorsUseCase {
  final CarRepository _repository;

  GetCarColorsUseCase(this._repository);

  Future<Either<Failure, List<CarColor>>> call() {
    return _repository.getCarColors();
  }
}
