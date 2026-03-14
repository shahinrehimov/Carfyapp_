import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCarUseCase {
  final CarRepository _repository;

  GetCarUseCase(this._repository);

  Future<Either<Failure, UserCar>> call(int id) {
    return _repository.getCar(id);
  }
}
