part of 'order_detail_cubit.dart';

class OrderDetailState extends Equatable {
  final StateStatus status;
  final OrderDetail? order;

  const OrderDetailState({required this.status, this.order});

  factory OrderDetailState.initial() => OrderDetailState(status: StateStatus.loading());

  OrderDetailState copyWith({StateStatus? status, OrderDetail? order}) {
    return OrderDetailState(status: status ?? this.status, order: order ?? this.order);
  }

  @override
  List<Object?> get props => [status, order];
}
