part of 'basket_manager_cubit.dart';

class BasketManagerState extends Equatable {
  final Map<int, StateStatus> productLoadingStates;
  final StateStatus basketActionStatus;

  const BasketManagerState({
    this.productLoadingStates = const {},
    this.basketActionStatus = const StateStatus(),
  });

  factory BasketManagerState.initial() => BasketManagerState(
        productLoadingStates: {},
        basketActionStatus: StateStatus.initial(),
      );

  bool isLoading(int productId) => productLoadingStates[productId] is StateStatusLoading;

  bool get isBasketActionLoading => basketActionStatus is StateStatusLoading;

  StateStatus? getStatus(int productId) => productLoadingStates[productId];

  BasketManagerState copyWith({
    Map<int, StateStatus>? productLoadingStates,
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
