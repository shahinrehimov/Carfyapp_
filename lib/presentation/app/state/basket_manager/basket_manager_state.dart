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
  final Set<String> basketIds;

  const BasketManagerState({
    this.productLoadingStates = const {},
    this.basketActionStatus = const StateStatus(),
    this.quantityUpdate,
    this.basketIds = const {},
  });

  factory BasketManagerState.initial() =>
      BasketManagerState(productLoadingStates: {}, basketActionStatus: StateStatus.initial());

  bool isLoading(String cpvUuid) => productLoadingStates[cpvUuid] is StateStatusLoading;

  bool get isBasketActionLoading => basketActionStatus is StateStatusLoading;

  bool isInBasket(String cpvUuid) => basketIds.contains(cpvUuid);

  StateStatus? getStatus(String cpvUuid) => productLoadingStates[cpvUuid];

  BasketManagerState copyWith({
    Map<String, StateStatus>? productLoadingStates,
    StateStatus? basketActionStatus,
    QuantityUpdate? quantityUpdate,
    Set<String>? basketIds,
  }) {
    return BasketManagerState(
      productLoadingStates: productLoadingStates ?? this.productLoadingStates,
      basketActionStatus: basketActionStatus ?? this.basketActionStatus,
      quantityUpdate: quantityUpdate,
      basketIds: basketIds ?? this.basketIds,
    );
  }

  @override
  List<Object?> get props => [productLoadingStates, basketActionStatus, quantityUpdate, basketIds];
}
