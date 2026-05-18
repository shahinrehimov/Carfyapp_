part of 'group_products_cubit.dart';

class GroupProductsState extends Equatable {
  final StateStatus status;
  final List<Product> products;

  const GroupProductsState({required this.status, this.products = const []});

  factory GroupProductsState.initial() => GroupProductsState(status: StateStatus.initial());

  GroupProductsState copyWith({StateStatus? status, List<Product>? products}) {
    return GroupProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [status, products];
}
