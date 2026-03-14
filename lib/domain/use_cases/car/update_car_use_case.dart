import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/params/car/update_car_params.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCarUseCase {
  final CarRepository _repository;

  UpdateCarUseCase(this._repository);

  Future<Either<Failure, UserCar>> call(UpdateCarParams params) {
    return _repository.updateCar(params);
  }
}
