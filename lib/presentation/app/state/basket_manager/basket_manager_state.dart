part of 'basket_manager_cubit.dart';

class BasketManagerState extends Equatable {
  final Map<String, StateStatus> productLoadingStates;
  final StateStatus basketActionStatus;

  const BasketManagerState({
    this.productLoadingStates = const {},
    this.basketActionStatus = const StateStatus(),
  });

  factory BasketManagerState.initial() => BasketManagerState(
        productLoadingStates: {},
        basketActionStatus: StateStatus.initial(),
      );

  bool isLoading(String cpvUuid) => productLoadingStates[cpvUuid] is StateStatusLoading;

  bool get isBasketActionLoading => basketActionStatus is StateStatusLoading;

  StateStatus? getStatus(String cpvUuid) => productLoadingStates[cpvUuid];

  BasketManagerState copyWith({
    Map<String, StateStatus>? productLoadingStates,
    StateStatus? basketActionStatus,
  }) {
    return BasketManagerState(
      productLoadingStates: productLoadingStates ?? this.productLoadingStates,
      basketActionStatus: basketActionStatus ?? this.basketActionStatus,
    );
  }

  @override
  List<Object?> get props => [productLoadingStates, basketActionStatus];
}
