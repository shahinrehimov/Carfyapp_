part of 'order_confirm_cubit.dart';

class OrderConfirmState extends Equatable {
  final StateStatus previewStatus;
  final CheckoutPreview? preview;
  final Address? selectedAddress;
  final StateStatus paymentMethodsStatus;
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedPaymentMethod;

  const OrderConfirmState({
    required this.previewStatus,
    this.preview,
    this.selectedAddress,
    required this.paymentMethodsStatus,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
  });

  factory OrderConfirmState.initial() => OrderConfirmState(
        previewStatus: StateStatus.initial(),
        paymentMethodsStatus: StateStatus.initial(),
      );

  OrderConfirmState copyWith({
    StateStatus? previewStatus,
    CheckoutPreview? preview,
    Address? selectedAddress,
    StateStatus? paymentMethodsStatus,
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? selectedPaymentMethod,
  }) {
    return OrderConfirmState(
      previewStatus: previewStatus ?? this.previewStatus,
      preview: preview ?? this.preview,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethodsStatus: paymentMethodsStatus ?? this.paymentMethodsStatus,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [
        previewStatus,
        preview,
        selectedAddress,
        paymentMethodsStatus,
        paymentMethods,
        selectedPaymentMethod,
      ];
}
