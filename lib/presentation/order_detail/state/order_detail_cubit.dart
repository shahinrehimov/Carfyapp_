import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/domain/use_cases/orders/get_order_details_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> with StateMapHelper {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  OrderDetailCubit({GetOrderDetailsUseCase? getOrderDetailsUseCase})
      : _getOrderDetailsUseCase = getOrderDetailsUseCase ?? getIt<GetOrderDetailsUseCase>(),
        super(OrderDetailState.initial());

  Future<void> init(int orderId) async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getOrderDetailsUseCase(orderId);
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (detail) => emit(state.copyWith(status: StateStatus.success(), order: detail)),
    );
  }
}
