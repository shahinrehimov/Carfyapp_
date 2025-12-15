import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/use_cases/product/get_wishlist_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> with StateMapHelper {
  final GetWishlistUseCase _getWishlistUseCase;
  final PaginationHelper _paginationHelper = PaginationHelper();

  WishlistCubit({GetWishlistUseCase? getWishlistUseCase})
    : _getWishlistUseCase = getWishlistUseCase ?? getIt<GetWishlistUseCase>(),
      super(WishlistState.initial());

  Future<void> init() async {
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    if (!_paginationHelper.shouldLoad()) return;

    emit(state.copyWith(status: _paginationHelper.getLoadingStatus()));
    _paginationHelper.onLoadStart();

    final result = await _getWishlistUseCase(
      ProductListParams(page: _paginationHelper.currentPage, limit: 10),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: mapFailure(failure)));
      },
      (response) {
        _paginationHelper.onLoadEnd(response.lastPage);
        final updatedProducts = [...state.products, ...response.data];
        emit(state.copyWith(status: StateStatus.success(), products: updatedProducts));
      },
    );
  }

  Future<void> loadNextPage() async {
    await _loadWishlist();
  }
}
