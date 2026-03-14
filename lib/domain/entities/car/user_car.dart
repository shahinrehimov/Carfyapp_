import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';

class UserCar {
  final int id;
  final String? photo;
  final CarLibraryItem brand;
  final CarLibraryItem brandModel;
  final CarLibraryItem carType;
  final EngineVolume? engineVolume;
  final CarLibraryItem? fuelType;
  final CarLibraryItem? transmissionType;
  final int year;
  final String? engineNumber;
  final String? vinNumber;
  final String createdAt;

  UserCar({
    required this.id,
    this.photo,
    required this.brand,
    required this.brandModel,
    required this.carType,
    this.engineVolume,
    this.fuelType,
    this.transmissionType,
    required this.year,
    this.engineNumber,
    this.vinNumber,
    required this.createdAt,
  });
}
