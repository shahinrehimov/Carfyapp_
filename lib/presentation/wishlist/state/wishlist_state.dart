part of 'wishlist_cubit.dart';

class WishlistState extends Equatable {
  final StateStatus status;
  final List<Product> products;

  const WishlistState({
    required this.status,
    required this.products,
  });

  factory WishlistState.initial() => WishlistState(
    status: StateStatus.initial(),
    products: [],
  );

  WishlistState copyWith({
    StateStatus? status,
    List<Product>? products,
  }) {
    return WishlistState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, products];
}
