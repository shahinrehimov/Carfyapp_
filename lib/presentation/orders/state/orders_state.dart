part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final StateStatus status;
  final List<OrderSummary> orders;

  const OrdersState({required this.status, required this.orders});

  factory OrdersState.initial() => OrdersState(status: StateStatus.loading(), orders: []);

  OrdersState copyWith({StateStatus? status, List<OrderSummary>? orders}) {
    return OrdersState(status: status ?? this.status, orders: orders ?? this.orders);
  }

  @override
  List<Object?> get props => [status, orders];
}
