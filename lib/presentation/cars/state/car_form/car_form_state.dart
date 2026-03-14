part of 'car_form_cubit.dart';

class CarFormState extends Equatable {
  final StateStatus brandsStatus;
  final StateStatus modelsStatus;
  final StateStatus engineVolumesStatus;
  final StateStatus fuelTypesStatus;
  final StateStatus transmissionTypesStatus;
  final StateStatus carTypesStatus;
  final StateStatus submitStatus;
  final StateStatus deleteStatus;

  final List<CarLibraryItem> brands;
  final List<CarLibraryItem> models;
  final List<EngineVolume> engineVolumes;
  final List<CarLibraryItem> fuelTypes;
  final List<CarLibraryItem> transmissionTypes;
  final List<CarLibraryItem> carTypes;

  final CarLibraryItem? selectedBrand;
  final CarLibraryItem? selectedModel;
  final EngineVolume? selectedEngineVolume;
  final CarLibraryItem? selectedFuelType;
  final CarLibraryItem? selectedTransmissionType;
  final CarLibraryItem? selectedCarType;

  final String year;
  final String engineNumber;
  final String vinNumber;

  const CarFormState({
    required this.brandsStatus,
    required this.modelsStatus,
    required this.engineVolumesStatus,
    required this.fuelTypesStatus,
    required this.transmissionTypesStatus,
    required this.carTypesStatus,
    required this.submitStatus,
    required this.deleteStatus,
    required this.brands,
    required this.models,
    required this.engineVolumes,
    required this.fuelTypes,
    required this.transmissionTypes,
    required this.carTypes,
    this.selectedBrand,
    this.selectedModel,
    this.selectedEngineVolume,
    this.selectedFuelType,
    this.selectedTransmissionType,
    this.selectedCarType,
    required this.year,
    required this.engineNumber,
    required this.vinNumber,
  });

  factory CarFormState.initial() => CarFormState(
    brandsStatus: StateStatus.initial(),
    modelsStatus: StateStatus.initial(),
    engineVolumesStatus: StateStatus.initial(),
    fuelTypesStatus: StateStatus.initial(),
    transmissionTypesStatus: StateStatus.initial(),
    carTypesStatus: StateStatus.initial(),
    submitStatus: StateStatus.initial(),
    deleteStatus: StateStatus.initial(),
    brands: [],
    models: [],
    engineVolumes: [],
    fuelTypes: [],
    transmissionTypes: [],
    carTypes: [],
    year: '',
    engineNumber: '',
    vinNumber: '',
  );

  CarFormState copyWith({
    StateStatus? brandsStatus,
    StateStatus? modelsStatus,
    StateStatus? engineVolumesStatus,
    StateStatus? fuelTypesStatus,
    StateStatus? transmissionTypesStatus,
    StateStatus? carTypesStatus,
    StateStatus? submitStatus,
    StateStatus? deleteStatus,
    List<CarLibraryItem>? brands,
    List<CarLibraryItem>? models,
    List<EngineVolume>? engineVolumes,
    List<CarLibraryItem>? fuelTypes,
    List<CarLibraryItem>? transmissionTypes,
    List<CarLibraryItem>? carTypes,
    CarLibraryItem? selectedBrand,
    CarLibraryItem? selectedModel,
    EngineVolume? selectedEngineVolume,
    CarLibraryItem? selectedFuelType,
    CarLibraryItem? selectedTransmissionType,
    CarLibraryItem? selectedCarType,
    String? year,
    String? engineNumber,
    String? vinNumber,
    bool clearSelectedModel = false,
    bool clearSelectedEngineVolume = false,
    bool clearSelectedFuelType = false,
    bool clearSelectedTransmissionType = false,
  }) {
    return CarFormState(
      brandsStatus: brandsStatus ?? this.brandsStatus,
      modelsStatus: modelsStatus ?? this.modelsStatus,
      engineVolumesStatus: engineVolumesStatus ?? this.engineVolumesStatus,
      fuelTypesStatus: fuelTypesStatus ?? this.fuelTypesStatus,
      transmissionTypesStatus: transmissionTypesStatus ?? this.transmissionTypesStatus,
      carTypesStatus: carTypesStatus ?? this.carTypesStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      engineVolumes: engineVolumes ?? this.engineVolumes,
      fuelTypes: fuelTypes ?? this.fuelTypes,
      transmissionTypes: transmissionTypes ?? this.transmissionTypes,
      carTypes: carTypes ?? this.carTypes,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: clearSelectedModel ? null : (selectedModel ?? this.selectedModel),
      selectedEngineVolume: clearSelectedEngineVolume ? null : (selectedEngineVolume ?? this.selectedEngineVolume),
      selectedFuelType: clearSelectedFuelType ? null : (selectedFuelType ?? this.selectedFuelType),
      selectedTransmissionType: clearSelectedTransmissionType
          ? null
          : (selectedTransmissionType ?? this.selectedTransmissionType),
      selectedCarType: selectedCarType ?? this.selectedCarType,
      year: year ?? this.year,
      engineNumber: engineNumber ?? this.engineNumber,
      vinNumber: vinNumber ?? this.vinNumber,
    );
  }

  @override
  List<Object?> get props => [
    brandsStatus,
    modelsStatus,
    engineVolumesStatus,
    fuelTypesStatus,
    transmissionTypesStatus,
    carTypesStatus,
    submitStatus,
    deleteStatus,
    brands,
    models,
    engineVolumes,
    fuelTypes,
    transmissionTypes,
    carTypes,
    selectedBrand,
    selectedModel,
    selectedEngineVolume,
    selectedFuelType,
    selectedTransmissionType,
    selectedCarType,
    year,
    engineNumber,
    vinNumber,
  ];
}
