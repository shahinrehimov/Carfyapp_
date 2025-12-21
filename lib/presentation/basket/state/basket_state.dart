part of 'basket_cubit.dart';

class BasketState extends Equatable {
  final StateStatus basketStatus;
  final List<BasketProduct> items;
  final BasketData? basketData;

  const BasketState({required this.basketStatus, required this.items, this.basketData});

  factory BasketState.initial() => BasketState(basketStatus: StateStatus.loading(), items: []);

  BasketState copyWith({StateStatus? basketStatus, List<BasketProduct>? items, BasketData? basketData}) {
    return BasketState(
      basketStatus: basketStatus ?? this.basketStatus,
      items: items ?? this.items,
      basketData: basketData ?? this.basketData,
    );
  }

  @override
  List<Object?> get props => [basketStatus, items, basketData];
}
