import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/car/car_library_item.dart';
import 'package:carfy/domain/entities/car/engine_volume.dart';
import 'package:carfy/domain/entities/car/user_car.dart';
import 'package:carfy/domain/params/car/add_car_params.dart';
import 'package:carfy/domain/params/car/update_car_params.dart';
import 'package:carfy/domain/use_cases/car/add_car_use_case.dart';
import 'package:carfy/domain/use_cases/car/delete_car_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_brand_models_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_brands_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_car_types_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_engine_volumes_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_fuel_types_use_case.dart';
import 'package:carfy/domain/use_cases/car/get_transmission_types_use_case.dart';
import 'package:carfy/domain/use_cases/car/update_car_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_form_state.dart';

class CarFormCubit extends Cubit<CarFormState> with StateMapHelper {
  final GetBrandsUseCase _getBrandsUseCase;
  final GetBrandModelsUseCase _getBrandModelsUseCase;
  final GetEngineVolumesUseCase _getEngineVolumesUseCase;
  final GetFuelTypesUseCase _getFuelTypesUseCase;
  final GetTransmissionTypesUseCase _getTransmissionTypesUseCase;
  final GetCarTypesUseCase _getCarTypesUseCase;
  final AddCarUseCase _addCarUseCase;
  final UpdateCarUseCase _updateCarUseCase;
  final DeleteCarUseCase _deleteCarUseCase;

  CarFormCubit({
    GetBrandsUseCase? getBrandsUseCase,
    GetBrandModelsUseCase? getBrandModelsUseCase,
    GetEngineVolumesUseCase? getEngineVolumesUseCase,
    GetFuelTypesUseCase? getFuelTypesUseCase,
    GetTransmissionTypesUseCase? getTransmissionTypesUseCase,
    GetCarTypesUseCase? getCarTypesUseCase,
    AddCarUseCase? addCarUseCase,
    UpdateCarUseCase? updateCarUseCase,
    DeleteCarUseCase? deleteCarUseCase,
  })  : _getBrandsUseCase = getBrandsUseCase ?? getIt<GetBrandsUseCase>(),
        _getBrandModelsUseCase = getBrandModelsUseCase ?? getIt<GetBrandModelsUseCase>(),
        _getEngineVolumesUseCase = getEngineVolumesUseCase ?? getIt<GetEngineVolumesUseCase>(),
        _getFuelTypesUseCase = getFuelTypesUseCase ?? getIt<GetFuelTypesUseCase>(),
        _getTransmissionTypesUseCase = getTransmissionTypesUseCase ?? getIt<GetTransmissionTypesUseCase>(),
        _getCarTypesUseCase = getCarTypesUseCase ?? getIt<GetCarTypesUseCase>(),
        _addCarUseCase = addCarUseCase ?? getIt<AddCarUseCase>(),
        _updateCarUseCase = updateCarUseCase ?? getIt<UpdateCarUseCase>(),
        _deleteCarUseCase = deleteCarUseCase ?? getIt<DeleteCarUseCase>(),
        super(CarFormState.initial());

  Future<void> init(UserCar? car) async {
    if (car != null) {
      emit(state.copyWith(
        selectedBrand: car.brand,
        selectedModel: car.brandModel,
        selectedEngineVolume: car.engineVolume,
        selectedFuelType: car.fuelType,
        selectedTransmissionType: car.transmissionType,
        selectedCarType: car.carType,
        year: car.year.toString(),
        engineNumber: car.engineNumber ?? '',
        vinNumber: car.vinNumber ?? '',
      ));
    }
    await Future.wait([
      _loadBrands(),
      _loadEngineVolumes(),
      _loadFuelTypes(),
      _loadTransmissionTypes(),
      _loadCarTypes(),
    ]);
    if (car != null) {
      await _loadBrandModels(car.brand.id);
    }
  }

  Future<void> _loadBrands() async {
    emit(state.copyWith(brandsStatus: StateStatus.loading()));
    final result = await _getBrandsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(brandsStatus: mapFailure(failure))),
      (brands) => emit(state.copyWith(brandsStatus: StateStatus.success(), brands: brands)),
    );
  }

  Future<void> _loadBrandModels(int brandId) async {
    emit(state.copyWith(modelsStatus: StateStatus.loading(), models: []));
    final result = await _getBrandModelsUseCase(brandId);
    result.fold(
      (failure) => emit(state.copyWith(modelsStatus: mapFailure(failure))),
      (models) => emit(state.copyWith(modelsStatus: StateStatus.success(), models: models)),
    );
  }

  Future<void> _loadEngineVolumes() async {
    emit(state.copyWith(engineVolumesStatus: StateStatus.loading()));
    final result = await _getEngineVolumesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(engineVolumesStatus: mapFailure(failure))),
      (volumes) => emit(state.copyWith(engineVolumesStatus: StateStatus.success(), engineVolumes: volumes)),
    );
  }

  Future<void> _loadFuelTypes() async {
    emit(state.copyWith(fuelTypesStatus: StateStatus.loading()));
    final result = await _getFuelTypesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(fuelTypesStatus: mapFailure(failure))),
      (types) => emit(state.copyWith(fuelTypesStatus: StateStatus.success(), fuelTypes: types)),
    );
  }

  Future<void> _loadTransmissionTypes() async {
    emit(state.copyWith(transmissionTypesStatus: StateStatus.loading()));
    final result = await _getTransmissionTypesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(transmissionTypesStatus: mapFailure(failure))),
      (types) => emit(state.copyWith(transmissionTypesStatus: StateStatus.success(), transmissionTypes: types)),
    );
  }

  Future<void> _loadCarTypes() async {
    emit(state.copyWith(carTypesStatus: StateStatus.loading()));
    final result = await _getCarTypesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(carTypesStatus: mapFailure(failure))),
      (types) => emit(state.copyWith(carTypesStatus: StateStatus.success(), carTypes: types)),
    );
  }

  void selectBrand(CarLibraryItem brand) {
    emit(state.copyWith(selectedBrand: brand, clearSelectedModel: true, models: [], modelsStatus: StateStatus.initial()));
    _loadBrandModels(brand.id);
  }

  void selectModel(CarLibraryItem model) => emit(state.copyWith(selectedModel: model));

  void selectEngineVolume(EngineVolume volume) => emit(state.copyWith(selectedEngineVolume: volume));

  void selectFuelType(CarLibraryItem type) => emit(state.copyWith(selectedFuelType: type));

  void selectTransmissionType(CarLibraryItem type) => emit(state.copyWith(selectedTransmissionType: type));

  void selectCarType(CarLibraryItem type) => emit(state.copyWith(selectedCarType: type));

  void setYear(String year) => emit(state.copyWith(year: year));

  void setEngineNumber(String value) => emit(state.copyWith(engineNumber: value));

  void setVinNumber(String value) => emit(state.copyWith(vinNumber: value));

  Future<void> save({UserCar? car}) async {
    final selectedBrand = state.selectedBrand;
    final selectedModel = state.selectedModel;
    final selectedCarType = state.selectedCarType;
    final year = int.tryParse(state.year);

    if (selectedModel == null || selectedCarType == null || year == null) return;

    emit(state.copyWith(submitStatus: StateStatus.loading()));

    if (car == null) {
      final params = AddCarParams(
        brandModelId: selectedModel.id,
        carTypeId: selectedCarType.id,
        year: year,
        engineVolumeId: state.selectedEngineVolume?.id,
        fuelTypeId: state.selectedFuelType?.id,
        transmissionTypeId: state.selectedTransmissionType?.id,
        engineNumber: state.engineNumber.isEmpty ? null : state.engineNumber,
        vinNumber: state.vinNumber.isEmpty ? null : state.vinNumber,
      );
      final result = await _addCarUseCase(params);
      result.fold(
        (failure) => emit(state.copyWith(submitStatus: mapFailure(failure))),
        (_) => emit(state.copyWith(submitStatus: StateStatus.success())),
      );
    } else {
      final params = UpdateCarParams(
        carId: car.id,
        brandModelId: selectedModel.id,
        carTypeId: selectedCarType.id,
        year: year,
        engineVolumeId: state.selectedEngineVolume?.id,
        fuelTypeId: state.selectedFuelType?.id,
        transmissionTypeId: state.selectedTransmissionType?.id,
        engineNumber: state.engineNumber.isEmpty ? null : state.engineNumber,
        vinNumber: state.vinNumber.isEmpty ? null : state.vinNumber,
      );
      final result = await _updateCarUseCase(params);
      result.fold(
        (failure) => emit(state.copyWith(submitStatus: mapFailure(failure))),
        (_) => emit(state.copyWith(submitStatus: StateStatus.success())),
      );
    }
  }

  Future<void> deleteCar(int carId) async {
    emit(state.copyWith(deleteStatus: StateStatus.loading()));
    final result = await _deleteCarUseCase(carId);
    result.fold(
      (failure) => emit(state.copyWith(deleteStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(deleteStatus: StateStatus.success())),
    );
  }
}
