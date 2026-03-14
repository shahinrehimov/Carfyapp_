import 'package:carfy/data/models/car/car_library_item_model.dart';
import 'package:carfy/data/models/car/engine_volume_model.dart';

class UserCarModel {
  final int id;
  final String? photo;
  final CarLibraryItemModel brand;
  final CarLibraryItemModel brandModel;
  final CarLibraryItemModel carType;
  final EngineVolumeModel? engineVolume;
  final CarLibraryItemModel? fuelType;
  final CarLibraryItemModel? transmissionType;
  final int year;
  final String? engineNumber;
  final String? vinNumber;
  final String createdAt;

  UserCarModel({
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

  factory UserCarModel.fromJson(Map<String, dynamic> json) {
    return UserCarModel(
      id: json['id'] as int,
      photo: json['photo'] as String?,
      brand: CarLibraryItemModel.fromJson(json['brand'] as Map<String, dynamic>),
      brandModel: CarLibraryItemModel.fromJson(json['brand_model'] as Map<String, dynamic>),
      carType: CarLibraryItemModel.fromJson(json['car_type'] as Map<String, dynamic>),
      engineVolume: json['engine_volume'] != null
          ? EngineVolumeModel.fromJson(json['engine_volume'] as Map<String, dynamic>)
          : null,
      fuelType: json['fuel_type'] != null
          ? CarLibraryItemModel.fromJson(json['fuel_type'] as Map<String, dynamic>)
          : null,
      transmissionType: json['transmission_type'] != null
          ? CarLibraryItemModel.fromJson(json['transmission_type'] as Map<String, dynamic>)
          : null,
      year: json['year'] as int,
      engineNumber: json['engine_number'] as String?,
      vinNumber: json['vin_number'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
