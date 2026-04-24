import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetEngineVolumesUseCase {
  final CarRepository _repository;

  GetEngineVolumesUseCase(this._repository);

  Future<Either<Failure, List<EngineVolume>>> call() {
    return _repository.getEngineVolumes();
  }
}
