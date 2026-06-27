import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/address/address_type.dart';
import 'package:carfy/domain/entities/address/city.dart';
import 'package:carfy/domain/entities/address/flat_city.dart';
import 'package:carfy/domain/params/address/add_address_params.dart';
import 'package:carfy/domain/params/address/update_address_params.dart';
import 'package:carfy/domain/use_cases/address/add_address_use_case.dart';
import 'package:carfy/domain/use_cases/address/delete_address_use_case.dart';
import 'package:carfy/domain/use_cases/address/get_address_types_use_case.dart';
import 'package:carfy/domain/use_cases/address/get_countries_with_cities_use_case.dart';
import 'package:carfy/domain/use_cases/address/update_address_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'address_form_state.dart';

class AddressFormCubit extends Cubit<AddressFormState> with StateMapHelper {
  final GetAddressTypesUseCase _getAddressTypesUseCase;
  final GetCountriesWithCitiesUseCase _getCountriesWithCitiesUseCase;
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  AddressFormCubit({
    GetAddressTypesUseCase? getAddressTypesUseCase,
    GetCountriesWithCitiesUseCase? getCountriesWithCitiesUseCase,
    AddAddressUseCase? addAddressUseCase,
    UpdateAddressUseCase? updateAddressUseCase,
    DeleteAddressUseCase? deleteAddressUseCase,
  }) : _getAddressTypesUseCase = getAddressTypesUseCase ?? getIt<GetAddressTypesUseCase>(),
       _getCountriesWithCitiesUseCase = getCountriesWithCitiesUseCase ?? getIt<GetCountriesWithCitiesUseCase>(),
       _addAddressUseCase = addAddressUseCase ?? getIt<AddAddressUseCase>(),
       _updateAddressUseCase = updateAddressUseCase ?? getIt<UpdateAddressUseCase>(),
       _deleteAddressUseCase = deleteAddressUseCase ?? getIt<DeleteAddressUseCase>(),
       super(AddressFormState.initial());

  Future<void> init(Address? address) async {
    if (address != null) {
      emit(
        state.copyWith(
          addressLine1: address.addressLine1,
          addressLine2: address.addressLine2 ?? '',
          phone: address.phone,
          latitude: address.latitude,
          longitude: address.longitude,
        ),
      );
    }
    await Future.wait([_loadAddressTypes(), _loadCities()]);
    // Pre-select values after loading
    if (address != null) {
      final matchedType = state.addressTypes.where((t) => t.id == address.addressType.id).firstOrNull;
      final matchedCity = state.flatCities.where((c) => c.id == address.city.id).firstOrNull;
      emit(state.copyWith(selectedAddressType: matchedType, selectedCity: matchedCity));
    }
  }

  Future<void> _loadAddressTypes() async {
    emit(state.copyWith(addressTypesStatus: StateStatus.loading()));
    final result = await _getAddressTypesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(addressTypesStatus: mapFailure(failure))),
      (types) => emit(state.copyWith(addressTypesStatus: StateStatus.success(), addressTypes: types)),
    );
  }

  Future<void> _loadCities() async {
    emit(state.copyWith(citiesStatus: StateStatus.loading()));
    final result = await _getCountriesWithCitiesUseCase();
    result.fold((failure) => emit(state.copyWith(citiesStatus: mapFailure(failure))), (countries) {
      final flat = [
        for (final country in countries)
          for (final city in country.cities) FlatCity(id: city.id, title: city.title, countryTitle: country.title),
      ];
      emit(state.copyWith(citiesStatus: StateStatus.success(), countries: countries, flatCities: flat));
    });
  }

  Future<void> retryAddressTypes() => _loadAddressTypes();
  Future<void> retryCities() => _loadCities();

  void selectAddressType(AddressType type) =>
      emit(state.copyWith(selectedAddressType: type, clearAddressTypeError: true));
  void selectCity(FlatCity city) => emit(state.copyWith(selectedCity: city, clearCityError: true));
  void setAddressLine1(String v) => emit(state.copyWith(addressLine1: v));
  void setAddressLine2(String v) => emit(state.copyWith(addressLine2: v));
  void setPhone(String v) => emit(state.copyWith(phone: v));
  void setLocation(String latitude, String longitude) =>
      emit(state.copyWith(latitude: latitude, longitude: longitude, clearLocationError: true));

  Future<void> save({Address? address}) async {
    final hasType = state.selectedAddressType != null;
    final hasCity = state.selectedCity != null;
    final hasLine1 = state.addressLine1.trim().isNotEmpty;
    final hasPhone = state.phone.trim().isNotEmpty;
    final hasLocation = state.latitude != null && state.longitude != null;

    emit(
      state.copyWith(
        addressTypeError: hasType ? null : AddressFormFieldError.required,
        clearAddressTypeError: hasType,
        cityError: hasCity ? null : AddressFormFieldError.required,
        clearCityError: hasCity,
        addressLine1Error: hasLine1 ? null : AddressFormFieldError.required,
        clearAddressLine1Error: hasLine1,
        phoneError: hasPhone ? null : AddressFormFieldError.required,
        clearPhoneError: hasPhone,
        locationError: hasLocation ? null : AddressFormFieldError.required,
        clearLocationError: hasLocation,
      ),
    );

    if (!hasType || !hasCity || !hasLine1 || !hasPhone || !hasLocation) return;

    emit(state.copyWith(submitStatus: StateStatus.loading()));

    if (address == null) {
      final params = AddAddressParams(
        addressTypeId: state.selectedAddressType!.id,
        cityId: state.selectedCity!.id,
        addressLine1: state.addressLine1.trim(),
        addressLine2: state.addressLine2.trim().isEmpty ? null : state.addressLine2.trim(),
        latitude: state.latitude,
        longitude: state.longitude,
        phone: state.phone.trim(),
      );
      final result = await _addAddressUseCase(params);
      result.fold((failure) {
        emit(state.copyWith(submitStatus: mapFailure(failure)));
        if (failure is ValidationFailure) _emitValidationErrors(failure);
      }, (_) => emit(state.copyWith(submitStatus: StateStatus.success())));
    } else {
      final params = UpdateAddressParams(
        addressId: address.id,
        addressTypeId: state.selectedAddressType!.id,
        cityId: state.selectedCity!.id,
        addressLine1: state.addressLine1.trim(),
        addressLine2: state.addressLine2.trim().isEmpty ? null : state.addressLine2.trim(),
        latitude: state.latitude,
        longitude: state.longitude,
        phone: state.phone.trim(),
      );
      final result = await _updateAddressUseCase(params);
      result.fold((failure) {
        emit(state.copyWith(submitStatus: mapFailure(failure)));
        if (failure is ValidationFailure) _emitValidationErrors(failure);
      }, (_) => emit(state.copyWith(submitStatus: StateStatus.success())));
    }
  }

  void _emitValidationErrors(ValidationFailure failure) {
    emit(
      state.copyWith(
        addressLine1ValidationState: mapValidationFailure('address_line_1', failure),
        addressLine2ValidationState: mapValidationFailure('address_line_2', failure),
        phoneValidationState: mapValidationFailure('phone', failure),
      ),
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(state.copyWith(deleteStatus: StateStatus.loading()));
    final result = await _deleteAddressUseCase(id);
    result.fold(
      (failure) => emit(state.copyWith(deleteStatus: mapFailure(failure))),
      (_) => emit(state.copyWith(deleteStatus: StateStatus.success())),
    );
  }
}
