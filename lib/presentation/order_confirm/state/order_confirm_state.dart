part of 'order_confirm_cubit.dart';

class OrderConfirmState extends Equatable {
  final List<BasketProduct> basketItems;
  final StateStatus addressesStatus;
  final List<Address> addresses;
  final Address? selectedAddress;
  final StateStatus paymentMethodsStatus;
  final List<PaymentMethod> paymentMethods;
  final PaymentMethod? selectedPaymentMethod;
  final String note;
  final StateStatus previewStatus;
  final CheckoutPreview? preview;
  final StateStatus checkoutStatus;
  final CheckoutResult? checkoutResult;

  const OrderConfirmState({
    this.basketItems = const [],
    required this.addressesStatus,
    this.addresses = const [],
    this.selectedAddress,
    required this.paymentMethodsStatus,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
    this.note = '',
    required this.previewStatus,
    this.preview,
    required this.checkoutStatus,
    this.checkoutResult,
  });

  factory OrderConfirmState.initial({List<BasketProduct> basketItems = const []}) => OrderConfirmState(
        basketItems: basketItems,
        addressesStatus: StateStatus.initial(),
        paymentMethodsStatus: StateStatus.initial(),
        previewStatus: StateStatus.initial(),
        checkoutStatus: StateStatus.initial(),
      );

  OrderConfirmState copyWith({
    List<BasketProduct>? basketItems,
    StateStatus? addressesStatus,
    List<Address>? addresses,
    Address? selectedAddress,
    StateStatus? paymentMethodsStatus,
    List<PaymentMethod>? paymentMethods,
    PaymentMethod? selectedPaymentMethod,
    String? note,
    StateStatus? previewStatus,
    CheckoutPreview? preview,
    StateStatus? checkoutStatus,
    CheckoutResult? checkoutResult,
  }) {
    return OrderConfirmState(
      basketItems: basketItems ?? this.basketItems,
      addressesStatus: addressesStatus ?? this.addressesStatus,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethodsStatus: paymentMethodsStatus ?? this.paymentMethodsStatus,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      note: note ?? this.note,
      previewStatus: previewStatus ?? this.previewStatus,
      preview: preview ?? this.preview,
      checkoutStatus: checkoutStatus ?? this.checkoutStatus,
      checkoutResult: checkoutResult ?? this.checkoutResult,
    );
  }

  @override
  List<Object?> get props => [
        basketItems,
        addressesStatus,
        addresses,
        selectedAddress,
        paymentMethodsStatus,
        paymentMethods,
        selectedPaymentMethod,
        note,
        previewStatus,
        preview,
        checkoutStatus,
        checkoutResult,
      ];
}
