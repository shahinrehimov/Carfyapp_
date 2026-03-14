part of 'car_form_cubit.dart';

enum CarFormFieldError { required }

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
  final String? selectedPhotoPath; // newly picked local file
  final bool deleteExistingPhoto;  // user removed the existing network photo

  // Client-side validation errors
  final CarFormFieldError? brandError;
  final CarFormFieldError? modelError;
  final CarFormFieldError? carTypeError;
  final CarFormFieldError? yearError;

  // Server-side validation errors (from API 422)
  final FieldValidationState brandModelValidationState;
  final FieldValidationState carTypeValidationState;
  final FieldValidationState yearValidationState;
  final FieldValidationState engineNumberValidationState;
  final FieldValidationState vinNumberValidationState;

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
    this.selectedPhotoPath,
    this.deleteExistingPhoto = false,
    this.brandError,
    this.modelError,
    this.carTypeError,
    this.yearError,
    required this.brandModelValidationState,
    required this.carTypeValidationState,
    required this.yearValidationState,
    required this.engineNumberValidationState,
    required this.vinNumberValidationState,
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
    brandModelValidationState: FieldValidationState.pure(),
    carTypeValidationState: FieldValidationState.pure(),
    yearValidationState: FieldValidationState.pure(),
    engineNumberValidationState: FieldValidationState.pure(),
    vinNumberValidationState: FieldValidationState.pure(),
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
    String? selectedPhotoPath,
    bool? deleteExistingPhoto,
    bool clearSelectedPhoto = false,
    CarFormFieldError? brandError,
    CarFormFieldError? modelError,
    CarFormFieldError? carTypeError,
    CarFormFieldError? yearError,
    FieldValidationState? brandModelValidationState,
    FieldValidationState? carTypeValidationState,
    FieldValidationState? yearValidationState,
    FieldValidationState? engineNumberValidationState,
    FieldValidationState? vinNumberValidationState,
    bool clearBrandError = false,
    bool clearModelError = false,
    bool clearCarTypeError = false,
    bool clearYearError = false,
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
      selectedPhotoPath: clearSelectedPhoto ? null : (selectedPhotoPath ?? this.selectedPhotoPath),
      deleteExistingPhoto: deleteExistingPhoto ?? this.deleteExistingPhoto,
      brandError: clearBrandError ? null : (brandError ?? this.brandError),
      modelError: clearModelError ? null : (modelError ?? this.modelError),
      carTypeError: clearCarTypeError ? null : (carTypeError ?? this.carTypeError),
      yearError: clearYearError ? null : (yearError ?? this.yearError),
      brandModelValidationState: brandModelValidationState ?? this.brandModelValidationState,
      carTypeValidationState: carTypeValidationState ?? this.carTypeValidationState,
      yearValidationState: yearValidationState ?? this.yearValidationState,
      engineNumberValidationState: engineNumberValidationState ?? this.engineNumberValidationState,
      vinNumberValidationState: vinNumberValidationState ?? this.vinNumberValidationState,
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
    selectedPhotoPath,
    deleteExistingPhoto,
    brandError,
    modelError,
    carTypeError,
    yearError,
    brandModelValidationState,
    carTypeValidationState,
    yearValidationState,
    engineNumberValidationState,
    vinNumberValidationState,
  ];
}
