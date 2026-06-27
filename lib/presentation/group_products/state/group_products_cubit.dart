import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:carfy/domain/use_cases/group/get_group_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_products_state.dart';

class GroupProductsCubit extends Cubit<GroupProductsState> with StateMapHelper {
  final GetGroupUseCase _getGroupUseCase;

  GroupProductsCubit({GetGroupUseCase? getGroupUseCase})
    : _getGroupUseCase = getGroupUseCase ?? getIt<GetGroupUseCase>(),
      super(GroupProductsState.initial());

  Future<void> load(String slug) async {
    emit(state.copyWith(status: StateStatus.loading()));
    final result = await _getGroupUseCase(GroupParams(slug: slug, limit: 50));
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (group) => emit(
        state.copyWith(
          status: group.products.isEmpty ? StateStatus.empty() : StateStatus.success(),
          products: group.products,
        ),
      ),
    );
  }
}
