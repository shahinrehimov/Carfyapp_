import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteCarUseCase {
  final CarRepository _repository;

  DeleteCarUseCase(this._repository);

  Future<Either<Failure, String>> call(int id) {
    return _repository.deleteCar(id);
  }
}
