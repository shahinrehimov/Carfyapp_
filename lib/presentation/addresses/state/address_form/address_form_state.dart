part of 'address_form_cubit.dart';

enum AddressFormFieldError { required }

class AddressFormState extends Equatable {
  final StateStatus addressTypesStatus;
  final StateStatus citiesStatus;
  final StateStatus submitStatus;
  final StateStatus deleteStatus;

  final List<AddressType> addressTypes;
  final List<Country> countries;
  final List<FlatCity> flatCities;

  final AddressType? selectedAddressType;
  final FlatCity? selectedCity;

  final String addressLine1;
  final String addressLine2;
  final String phone;
  final String? latitude;
  final String? longitude;

  // Client-side errors
  final AddressFormFieldError? addressTypeError;
  final AddressFormFieldError? cityError;
  final AddressFormFieldError? addressLine1Error;
  final AddressFormFieldError? phoneError;
  final AddressFormFieldError? locationError;

  // Server-side errors
  final FieldValidationState addressLine1ValidationState;
  final FieldValidationState addressLine2ValidationState;
  final FieldValidationState phoneValidationState;

  const AddressFormState({
    required this.addressTypesStatus,
    required this.citiesStatus,
    required this.submitStatus,
    required this.deleteStatus,
    required this.addressTypes,
    required this.countries,
    required this.flatCities,
    this.selectedAddressType,
    this.selectedCity,
    required this.addressLine1,
    required this.addressLine2,
    required this.phone,
    this.latitude,
    this.longitude,
    this.addressTypeError,
    this.cityError,
    this.addressLine1Error,
    this.phoneError,
    this.locationError,
    required this.addressLine1ValidationState,
    required this.addressLine2ValidationState,
    required this.phoneValidationState,
  });

  factory AddressFormState.initial() => AddressFormState(
        addressTypesStatus: StateStatus.initial(),
        citiesStatus: StateStatus.initial(),
        submitStatus: StateStatus.initial(),
        deleteStatus: StateStatus.initial(),
        addressTypes: [],
        countries: [],
        flatCities: [],
        addressLine1: '',
        addressLine2: '',
        phone: '',
        addressLine1ValidationState: FieldValidationState.pure(),
        addressLine2ValidationState: FieldValidationState.pure(),
        phoneValidationState: FieldValidationState.pure(),
      );

  AddressFormState copyWith({
    StateStatus? addressTypesStatus,
    StateStatus? citiesStatus,
    StateStatus? submitStatus,
    StateStatus? deleteStatus,
    List<AddressType>? addressTypes,
    List<Country>? countries,
    List<FlatCity>? flatCities,
    AddressType? selectedAddressType,
    FlatCity? selectedCity,
    String? addressLine1,
    String? addressLine2,
    String? phone,
    String? latitude,
    String? longitude,
    AddressFormFieldError? addressTypeError,
    AddressFormFieldError? cityError,
    AddressFormFieldError? addressLine1Error,
    AddressFormFieldError? phoneError,
    AddressFormFieldError? locationError,
    FieldValidationState? addressLine1ValidationState,
    FieldValidationState? addressLine2ValidationState,
    FieldValidationState? phoneValidationState,
    bool clearAddressTypeError = false,
    bool clearCityError = false,
    bool clearAddressLine1Error = false,
    bool clearPhoneError = false,
    bool clearLocationError = false,
    bool clearLatLng = false,
  }) {
    return AddressFormState(
      addressTypesStatus: addressTypesStatus ?? this.addressTypesStatus,
      citiesStatus: citiesStatus ?? this.citiesStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      addressTypes: addressTypes ?? this.addressTypes,
      countries: countries ?? this.countries,
      flatCities: flatCities ?? this.flatCities,
      selectedAddressType: selectedAddressType ?? this.selectedAddressType,
      selectedCity: selectedCity ?? this.selectedCity,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      phone: phone ?? this.phone,
      latitude: clearLatLng ? null : (latitude ?? this.latitude),
      longitude: clearLatLng ? null : (longitude ?? this.longitude),
      addressTypeError: clearAddressTypeError ? null : (addressTypeError ?? this.addressTypeError),
      cityError: clearCityError ? null : (cityError ?? this.cityError),
      addressLine1Error: clearAddressLine1Error ? null : (addressLine1Error ?? this.addressLine1Error),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      locationError: clearLocationError ? null : (locationError ?? this.locationError),
      addressLine1ValidationState: addressLine1ValidationState ?? this.addressLine1ValidationState,
      addressLine2ValidationState: addressLine2ValidationState ?? this.addressLine2ValidationState,
      phoneValidationState: phoneValidationState ?? this.phoneValidationState,
    );
  }

  @override
  List<Object?> get props => [
        addressTypesStatus, citiesStatus, submitStatus, deleteStatus,
        addressTypes, countries, flatCities,
        selectedAddressType, selectedCity,
        addressLine1, addressLine2, phone, latitude, longitude,
        addressTypeError, cityError, addressLine1Error, phoneError, locationError,
        addressLine1ValidationState, addressLine2ValidationState, phoneValidationState,
      ];
}
