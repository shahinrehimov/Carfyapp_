import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:carfy/domain/params/orders/orders_load_params.dart';
import 'package:carfy/domain/use_cases/orders/load_orders_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> with StateMapHelper {
  final LoadOrdersUseCase _loadOrdersUseCase;
  final PaginationHelper _paginationHelper = PaginationHelper();

  OrdersCubit({LoadOrdersUseCase? loadOrdersUseCase})
      : _loadOrdersUseCase = loadOrdersUseCase ?? getIt<LoadOrdersUseCase>(),
        super(OrdersState.initial());

  Future<void> init() async {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (!_paginationHelper.shouldLoad()) return;

    emit(state.copyWith(status: _paginationHelper.getLoadingStatus()));
    _paginationHelper.onLoadStart();

    final result = await _loadOrdersUseCase(
      OrdersLoadParams(page: _paginationHelper.currentPage),
    );
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) {
        _paginationHelper.onLoadEnd(response.lastPage);
        final updatedOrders = [...state.orders, ...response.data];
        emit(state.copyWith(
          status: updatedOrders.isEmpty ? StateStatus.empty() : StateStatus.success(),
          orders: updatedOrders,
        ));
      },
    );
  }

  Future<void> loadNextPage() async {
    await _loadOrders();
  }

  Future<void> refresh() async {
    _paginationHelper.reset();
    if (!_paginationHelper.shouldLoad()) return;
    _paginationHelper.onLoadStart();

    final result = await _loadOrdersUseCase(
      OrdersLoadParams(page: _paginationHelper.currentPage),
    );
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) {
        _paginationHelper.onLoadEnd(response.lastPage);
        emit(state.copyWith(
          status: response.data.isEmpty ? StateStatus.empty() : StateStatus.success(),
          orders: response.data,
        ));
      },
    );
  }
}
