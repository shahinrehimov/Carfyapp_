import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/car/car_library_item_model.dart';
import 'package:carfy/data/models/car/engine_volume_model.dart';
import 'package:carfy/data/models/car/user_car_model.dart';
import 'package:carfy/domain/params/car/add_car_params.dart';
import 'package:carfy/domain/params/car/update_car_params.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class CarRemoteDataSource {
  Future<List<UserCarModel>> getCars({int? limit});
  Future<UserCarModel> getCar(int id);
  Future<UserCarModel> addCar(AddCarParams params);
  Future<UserCarModel> updateCar(UpdateCarParams params);
  Future<String> deleteCar(int id);
  Future<String> deleteCarPhoto(int id);
  Future<List<CarLibraryItemModel>> getFuelTypes();
  Future<List<CarLibraryItemModel>> getTransmissionTypes();
  Future<List<CarLibraryItemModel>> getCarTypes();
  Future<List<EngineVolumeModel>> getEngineVolumes();
  Future<List<CarLibraryItemModel>> getBrands();
  Future<List<CarLibraryItemModel>> getBrandModels(int brandId);
}

@Injectable(as: CarRemoteDataSource)
class CarRemoteDataSourceImpl extends CarRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<UserCarModel>> getCars({int? limit}) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carsLoad, queryParams: {if (limit != null) 'limit': limit}),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => UserCarModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<UserCarModel> getCar(int id) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carShow(id)),
      map: (json) => UserCarModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<UserCarModel> addCar(AddCarParams params) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('brand_model_id', params.brandModelId.toString()),
      MapEntry('car_type_id', params.carTypeId.toString()),
      MapEntry('year', params.year.toString()),
      if (params.engineVolumeId != null) MapEntry('engine_volume_id', params.engineVolumeId.toString()),
      if (params.fuelTypeId != null) MapEntry('fuel_type_id', params.fuelTypeId.toString()),
      if (params.transmissionTypeId != null) MapEntry('transmission_type_id', params.transmissionTypeId.toString()),
      if (params.engineNumber != null) MapEntry('engine_number', params.engineNumber!),
      if (params.vinNumber != null) MapEntry('vin_number', params.vinNumber!),
    ]);
    if (params.photoPath != null) {
      formData.files.add(MapEntry('photo', await MultipartFile.fromFile(params.photoPath!)));
    }
    return handleResponse(
      () => _networkManager.post(EndpointPaths.carsAdd, data: formData),
      map: (json) => UserCarModel.fromJson(json['data']['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<UserCarModel> updateCar(UpdateCarParams params) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('brand_model_id', params.brandModelId.toString()),
      MapEntry('car_type_id', params.carTypeId.toString()),
      MapEntry('year', params.year.toString()),
      if (params.engineVolumeId != null) MapEntry('engine_volume_id', params.engineVolumeId.toString()),
      if (params.fuelTypeId != null) MapEntry('fuel_type_id', params.fuelTypeId.toString()),
      if (params.transmissionTypeId != null) MapEntry('transmission_type_id', params.transmissionTypeId.toString()),
      if (params.engineNumber != null) MapEntry('engine_number', params.engineNumber!),
      if (params.vinNumber != null) MapEntry('vin_number', params.vinNumber!),
    ]);
    if (params.photoPath != null) {
      formData.files.add(MapEntry('photo', await MultipartFile.fromFile(params.photoPath!)));
    }
    return handleResponse(
      () => _networkManager.post(EndpointPaths.carUpdate(params.carId), data: formData),
      map: (json) => UserCarModel.fromJson(json['data']['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<String> deleteCar(int id) {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.carDelete(id)),
      map: (json) => json['data']['message'] as String,
    );
  }

  @override
  Future<String> deleteCarPhoto(int id) {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.carDeletePhoto(id)),
      map: (json) => json['data']['message'] as String,
    );
  }

  @override
  Future<List<CarLibraryItemModel>> getFuelTypes() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carLibraryFuelTypes),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => CarLibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<CarLibraryItemModel>> getTransmissionTypes() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carLibraryTransmissionTypes),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => CarLibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<CarLibraryItemModel>> getCarTypes() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carLibraryCarTypes),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => CarLibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<EngineVolumeModel>> getEngineVolumes() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.carLibraryEngineVolumes),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => EngineVolumeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<CarLibraryItemModel>> getBrands() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.brands),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => CarLibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<CarLibraryItemModel>> getBrandModels(int brandId) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.brandModels(brandId)),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => CarLibraryItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
