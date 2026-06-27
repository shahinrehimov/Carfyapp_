import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/orders/checkout_result.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/domain/params/orders/checkout_params.dart';
import 'package:carfy/domain/use_cases/address/get_addresses_use_case.dart';
import 'package:carfy/domain/use_cases/orders/checkout_use_case.dart';
import 'package:carfy/domain/use_cases/orders/get_checkout_preview_use_case.dart';
import 'package:carfy/domain/use_cases/payment/get_payment_methods_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_confirm_state.dart';

class OrderConfirmCubit extends Cubit<OrderConfirmState> with StateMapHelper {
  final GetCheckoutPreviewUseCase _getCheckoutPreviewUseCase;
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  final GetAddressesUseCase _getAddressesUseCase;
  final CheckoutUseCase _checkoutUseCase;

  OrderConfirmCubit({
    GetCheckoutPreviewUseCase? getCheckoutPreviewUseCase,
    GetPaymentMethodsUseCase? getPaymentMethodsUseCase,
    GetAddressesUseCase? getAddressesUseCase,
    CheckoutUseCase? checkoutUseCase,
  }) : _getCheckoutPreviewUseCase = getCheckoutPreviewUseCase ?? getIt<GetCheckoutPreviewUseCase>(),
       _getPaymentMethodsUseCase = getPaymentMethodsUseCase ?? getIt<GetPaymentMethodsUseCase>(),
       _getAddressesUseCase = getAddressesUseCase ?? getIt<GetAddressesUseCase>(),
       _checkoutUseCase = checkoutUseCase ?? getIt<CheckoutUseCase>(),
       super(OrderConfirmState.initial());

  Future<void> load() async {
    emit(state.copyWith(addressesStatus: StateStatus.loading(), paymentMethodsStatus: StateStatus.loading()));
    await Future.wait([_loadAddresses(), _loadPaymentMethods()]);
  }

  Future<void> _loadAddresses() async {
    final result = await _getAddressesUseCase();
    result.fold((failure) => emit(state.copyWith(addressesStatus: mapFailure(failure))), (addresses) {
      Address? primary;
      for (final a in addresses) {
        if (a.isDefault) {
          primary = a;
          break;
        }
      }
      primary ??= addresses.isNotEmpty ? addresses.first : null;
      emit(
        state.copyWith(
          addressesStatus: StateStatus.success(),
          addresses: addresses,
          selectedAddress: primary,
          previewStatus: primary == null ? StateStatus.initial() : null,
        ),
      );
      if (primary != null) {
        _loadPreview(primary.id);
      }
    });
  }

  Future<void> _loadPaymentMethods() async {
    final result = await _getPaymentMethodsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(paymentMethodsStatus: mapFailure(failure))),
      (methods) => emit(
        state.copyWith(
          paymentMethodsStatus: StateStatus.success(),
          paymentMethods: methods,
          selectedPaymentMethod: methods.isNotEmpty ? methods.first : null,
        ),
      ),
    );
  }

  Future<void> _loadPreview(int addressId) async {
    emit(state.copyWith(previewStatus: StateStatus.loading()));
    final result = await _getCheckoutPreviewUseCase(addressId);
    result.fold(
      (failure) => emit(state.copyWith(previewStatus: mapFailure(failure))),
      (preview) => emit(state.copyWith(previewStatus: StateStatus.success(), preview: preview)),
    );
  }

  void selectAddress(Address address) {
    if (state.selectedAddress?.id == address.id) return;
    emit(state.copyWith(selectedAddress: address));
    _loadPreview(address.id);
  }

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  void setNote(String note) {
    emit(state.copyWith(note: note));
  }

  void toggleUseReferralBalance(bool value) {
    emit(state.copyWith(useReferralBalance: value));
  }

  Future<void> checkout() async {
    final address = state.selectedAddress;
    final method = state.selectedPaymentMethod;
    if (address == null || method == null) return;

    emit(state.copyWith(checkoutStatus: StateStatus.loading()));

    final result = await _checkoutUseCase(
      CheckoutParams(
        paymentMethod: method.value,
        addressId: address.id,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        useReferralBalance: state.useReferralBalance,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(checkoutStatus: mapFailure(failure))),
      (checkoutResult) => emit(state.copyWith(checkoutStatus: StateStatus.success(), checkoutResult: checkoutResult)),
    );
  }

  void resetCheckoutStatus() {
    emit(state.copyWith(checkoutStatus: StateStatus.initial()));
  }
}
