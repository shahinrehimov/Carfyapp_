import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/orders/checkout_preview.dart';
import 'package:carfy/domain/entities/payment/payment_method.dart';
import 'package:carfy/domain/use_cases/orders/get_checkout_preview_use_case.dart';
import 'package:carfy/domain/use_cases/payment/get_payment_methods_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_confirm_state.dart';

class OrderConfirmCubit extends Cubit<OrderConfirmState> with StateMapHelper {
  final GetCheckoutPreviewUseCase _getCheckoutPreviewUseCase;
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;

  OrderConfirmCubit({
    GetCheckoutPreviewUseCase? getCheckoutPreviewUseCase,
    GetPaymentMethodsUseCase? getPaymentMethodsUseCase,
  })  : _getCheckoutPreviewUseCase = getCheckoutPreviewUseCase ?? getIt<GetCheckoutPreviewUseCase>(),
        _getPaymentMethodsUseCase = getPaymentMethodsUseCase ?? getIt<GetPaymentMethodsUseCase>(),
        super(OrderConfirmState.initial());

  Future<void> load() async {
    emit(state.copyWith(previewStatus: StateStatus.loading(), paymentMethodsStatus: StateStatus.loading()));
    await Future.wait([_loadPreview(), _loadPaymentMethods()]);
  }

  Future<void> _loadPreview() async {
    final result = await _getCheckoutPreviewUseCase();
    result.fold(
      (failure) => emit(state.copyWith(previewStatus: mapFailure(failure))),
      (preview) => emit(state.copyWith(previewStatus: StateStatus.success(), preview: preview)),
    );
  }

  Future<void> _loadPaymentMethods() async {
    final result = await _getPaymentMethodsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(paymentMethodsStatus: mapFailure(failure))),
      (methods) => emit(state.copyWith(
        paymentMethodsStatus: StateStatus.success(),
        paymentMethods: methods,
        selectedPaymentMethod: methods.isNotEmpty ? methods.first : null,
      )),
    );
  }

  void selectAddress(Address address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }
}
