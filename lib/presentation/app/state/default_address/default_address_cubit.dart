import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/use_cases/address/get_addresses_use_case.dart';
import 'package:carfy/domain/use_cases/auth/check_logged_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'default_address_state.dart';

class DefaultAddressCubit extends Cubit<DefaultAddressState> {
  final GetAddressesUseCase _getAddressesUseCase;
  final CheckLoggedUseCase _checkLoggedUseCase;

  DefaultAddressCubit({GetAddressesUseCase? getAddressesUseCase, CheckLoggedUseCase? checkLoggedUseCase})
      : _getAddressesUseCase = getAddressesUseCase ?? getIt<GetAddressesUseCase>(),
        _checkLoggedUseCase = checkLoggedUseCase ?? getIt<CheckLoggedUseCase>(),
        super(const DefaultAddressState());

  Future<void> refresh() async {
    final loggedResult = await _checkLoggedUseCase();
    final isLoggedIn = loggedResult.getOrElse(() => false);
    if (!isLoggedIn) {
      emit(const DefaultAddressState());
      return;
    }
    final result = await _getAddressesUseCase();
    result.fold((_) {}, (addresses) {
      final defaultAddress = addresses.where((a) => a.isDefault).firstOrNull;
      emit(DefaultAddressState(address: defaultAddress));
    });
  }

  void clear() => emit(const DefaultAddressState());
}
