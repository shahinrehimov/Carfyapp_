part of 'basket_manager_cubit.dart';

class QuantityUpdate {
  final String cpvUuid;
  final int quantity;
  final BasketData basketData;

  const QuantityUpdate({required this.cpvUuid, required this.quantity, required this.basketData});
}

class BasketManagerState extends Equatable {
  final Map<String, StateStatus> productLoadingStates;
  final StateStatus basketActionStatus;
  final QuantityUpdate? quantityUpdate;

  const BasketManagerState({
    this.productLoadingStates = const {},
    this.basketActionStatus = const StateStatus(),
    this.quantityUpdate,
  });

  factory BasketManagerState.initial() =>
      BasketManagerState(productLoadingStates: {}, basketActionStatus: StateStatus.initial());

  bool isLoading(String cpvUuid) => productLoadingStates[cpvUuid] is StateStatusLoading;

  bool get isBasketActionLoading => basketActionStatus is StateStatusLoading;

  StateStatus? getStatus(String cpvUuid) => productLoadingStates[cpvUuid];

  BasketManagerState copyWith({
    Map<String, StateStatus>? productLoadingStates,
    StateStatus? basketActionStatus,
    QuantityUpdate? quantityUpdate,
  }) {
    return BasketManagerState(
      productLoadingStates: productLoadingStates ?? this.productLoadingStates,
      basketActionStatus: basketActionStatus ?? this.basketActionStatus,
      quantityUpdate: quantityUpdate,
    );
  }

  @override
  List<Object?> get props => [productLoadingStates, basketActionStatus, quantityUpdate];
}
