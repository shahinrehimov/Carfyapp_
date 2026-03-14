import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/entities/car/user_car_list_response.dart';
import 'package:carfy/domain/params/car/add_car_params.dart';
import 'package:carfy/domain/params/car/update_car_params.dart';
import 'package:dartz/dartz.dart';

abstract class CarRepository {
  Future<Either<Failure, UserCarListResponse>> getCars({int? limit});
  Future<Either<Failure, UserCar>> getCar(int id);
  Future<Either<Failure, UserCar>> addCar(AddCarParams params);
  Future<Either<Failure, UserCar>> updateCar(UpdateCarParams params);
  Future<Either<Failure, String>> deleteCar(int id);
  Future<Either<Failure, String>> deleteCarPhoto(int id);
  Future<Either<Failure, List<CarLibraryItem>>> getFuelTypes();
  Future<Either<Failure, List<CarLibraryItem>>> getTransmissionTypes();
  Future<Either<Failure, List<CarLibraryItem>>> getCarTypes();
  Future<Either<Failure, List<EngineVolume>>> getEngineVolumes();
  Future<Either<Failure, List<CarLibraryItem>>> getBrands();
  Future<Either<Failure, List<CarLibraryItem>>> getBrandModels(int brandId);
}
