import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/use_cases/address/delete_address_use_case.dart';
import 'package:carfy/domain/use_cases/address/get_addresses_use_case.dart';
import 'package:carfy/domain/use_cases/address/set_default_address_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'my_addresses_state.dart';

class MyAddressesCubit extends Cubit<MyAddressesState> with StateMapHelper {
  final GetAddressesUseCase _getAddressesUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;

  MyAddressesCubit({
    GetAddressesUseCase? getAddressesUseCase,
    DeleteAddressUseCase? deleteAddressUseCase,
    SetDefaultAddressUseCase? setDefaultAddressUseCase,
  })  : _getAddressesUseCase = getAddressesUseCase ?? getIt<GetAddressesUseCase>(),
        _deleteAddressUseCase = deleteAddressUseCase ?? getIt<DeleteAddressUseCase>(),
        _setDefaultAddressUseCase = setDefaultAddressUseCase ?? getIt<SetDefaultAddressUseCase>(),
        super(MyAddressesState.initial());

  Future<void> init() => _loadAddresses();

  Future<void> refresh() => _loadAddresses();

  Future<void> _loadAddresses() async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getAddressesUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (addresses) => emit(state.copyWith(status: StateStatus.success(), addresses: addresses)),
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(state.copyWith(deleteStatus: {...state.deleteStatus, id: StateStatus.loading()}));
    final result = await _deleteAddressUseCase(id);
    result.fold(
      (failure) {
        final updated = {...state.deleteStatus}..remove(id);
        emit(state.copyWith(deleteStatus: updated, status: mapFailure(failure)));
      },
      (message) {
        final updated = {...state.deleteStatus}..remove(id);
        final addresses = state.addresses.where((a) => a.id != id).toList();
        emit(state.copyWith(
          deleteStatus: updated,
          addresses: addresses,
          status: StateStatus.successWithMessage(message),
        ));
      },
    );
  }

  Future<void> setDefault(int id) async {
    emit(state.copyWith(setDefaultStatus: {...state.setDefaultStatus, id: StateStatus.loading()}));
    final result = await _setDefaultAddressUseCase(id);
    result.fold(
      (failure) {
        final updated = {...state.setDefaultStatus}..remove(id);
        emit(state.copyWith(setDefaultStatus: updated, status: mapFailure(failure)));
      },
      (message) {
        final updated = {...state.setDefaultStatus}..remove(id);
        final addresses = state.addresses.map((a) => _withDefault(a, a.id == id)).toList();
        emit(state.copyWith(
          setDefaultStatus: updated,
          addresses: addresses,
          status: StateStatus.successWithMessage(message),
        ));
      },
    );
  }

  Address _withDefault(Address a, bool isDefault) => Address(
        id: a.id,
        isDefault: isDefault,
        addressType: a.addressType,
        city: a.city,
        addressLine1: a.addressLine1,
        addressLine2: a.addressLine2,
        latitude: a.latitude,
        longitude: a.longitude,
        phone: a.phone,
      );
}
