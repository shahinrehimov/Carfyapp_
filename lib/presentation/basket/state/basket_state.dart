part of 'basket_cubit.dart';

class BasketState extends Equatable {
  final StateStatus basketStatus;
  final StateStatus basketActionStatus;
  final List<BasketProduct> items;
  final BasketData? basketData;
  final bool isAuthenticated;

  const BasketState({
    required this.basketStatus,
    required this.basketActionStatus,
    required this.items,
    this.basketData,
    this.isAuthenticated = false,
  });

  factory BasketState.initial() =>
      BasketState(basketStatus: StateStatus.loading(), basketActionStatus: StateStatus.initial(), items: []);

  bool get isActionLoading => basketActionStatus is StateStatusLoading;

  BasketState copyWith({
    StateStatus? basketStatus,
    StateStatus? basketActionStatus,
    List<BasketProduct>? items,
    BasketData? basketData,
    bool? isAuthenticated,
  }) {
    return BasketState(
      basketStatus: basketStatus ?? this.basketStatus,
      basketActionStatus: basketActionStatus ?? this.basketActionStatus,
      items: items ?? this.items,
      basketData: basketData ?? this.basketData,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [basketStatus, basketActionStatus, items, basketData, isAuthenticated];
}
