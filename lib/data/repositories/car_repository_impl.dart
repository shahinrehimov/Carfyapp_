import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/car_remote_data_source.dart';
import 'package:carfy/data/mappers/car_mapper.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/entities/car/user_car_list_response.dart';
import 'package:carfy/domain/params/car/add_car_params.dart';
import 'package:carfy/domain/params/car/update_car_params.dart';
import 'package:carfy/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CarRepository)
class CarRepositoryImpl extends CarRepository with RepositorySafeCallMixin {
  final CarRemoteDataSource _remoteDataSource;
  final CarMapper _mapper;

  CarRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, UserCarListResponse>> getCars({int? limit}) {
    return safeCall(() async {
      final models = await _remoteDataSource.getCars(limit: limit);
      return UserCarListResponse(
        cars: models.map(_mapper.mapUserCar).toList(),
        lastPage: 1,
      );
    });
  }

  @override
  Future<Either<Failure, UserCar>> getCar(int id) {
    return safeCall(() async {
      final model = await _remoteDataSource.getCar(id);
      return _mapper.mapUserCar(model);
    });
  }

  @override
  Future<Either<Failure, UserCar>> addCar(AddCarParams params) {
    return safeCall(() async {
      final model = await _remoteDataSource.addCar(params);
      return _mapper.mapUserCar(model);
    });
  }

  @override
  Future<Either<Failure, UserCar>> updateCar(UpdateCarParams params) {
    return safeCall(() async {
      final model = await _remoteDataSource.updateCar(params);
      return _mapper.mapUserCar(model);
    });
  }

  @override
  Future<Either<Failure, String>> deleteCar(int id) {
    return safeCall(() => _remoteDataSource.deleteCar(id));
  }

  @override
  Future<Either<Failure, String>> deleteCarPhoto(int id) {
    return safeCall(() => _remoteDataSource.deleteCarPhoto(id));
  }

  @override
  Future<Either<Failure, List<CarLibraryItem>>> getFuelTypes() {
    return safeCall(() async {
      final models = await _remoteDataSource.getFuelTypes();
      return models.map(_mapper.mapLibraryItem).toList();
    });
  }

  @override
  Future<Either<Failure, List<CarLibraryItem>>> getTransmissionTypes() {
    return safeCall(() async {
      final models = await _remoteDataSource.getTransmissionTypes();
      return models.map(_mapper.mapLibraryItem).toList();
    });
  }

  @override
  Future<Either<Failure, List<CarLibraryItem>>> getCarTypes() {
    return safeCall(() async {
      final models = await _remoteDataSource.getCarTypes();
      return models.map(_mapper.mapLibraryItem).toList();
    });
  }

  @override
  Future<Either<Failure, List<EngineVolume>>> getEngineVolumes() {
    return safeCall(() async {
      final models = await _remoteDataSource.getEngineVolumes();
      return models.map(_mapper.mapEngineVolume).toList();
    });
  }

  @override
  Future<Either<Failure, List<CarLibraryItem>>> getBrands() {
    return safeCall(() async {
      final models = await _remoteDataSource.getBrands();
      return models.map(_mapper.mapLibraryItem).toList();
    });
  }

  @override
  Future<Either<Failure, List<CarLibraryItem>>> getBrandModels(int brandId) {
    return safeCall(() async {
      final models = await _remoteDataSource.getBrandModels(brandId);
      return models.map(_mapper.mapLibraryItem).toList();
    });
  }
}
