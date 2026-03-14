import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/user_car_list_response.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCarsUseCase {
  final CarRepository _repository;

  GetCarsUseCase(this._repository);

  Future<Either<Failure, UserCarListResponse>> call({int? limit}) {
    return _repository.getCars(limit: limit);
  }
}
