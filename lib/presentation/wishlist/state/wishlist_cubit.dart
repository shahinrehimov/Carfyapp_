import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/domain/use_cases/wishlist/get_wishlist_use_case.dart';

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

    final result = await _getWishlistUseCase(ProductListParams(page: _paginationHelper.currentPage, limit: 10));
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

  Future<void> refresh() async {
    _paginationHelper.reset();
    if (!_paginationHelper.shouldLoad()) return;
    _paginationHelper.onLoadStart();

    final result = await _getWishlistUseCase(ProductListParams(page: _paginationHelper.currentPage, limit: 10));
    result.fold(
      (failure) {
        emit(state.copyWith(status: mapFailure(failure)));
      },
      (response) {
        _paginationHelper.onLoadEnd(response.lastPage);
        emit(state.copyWith(status: StateStatus.success(), products: response.data));
      },
    );
  }

  void removeProduct(String cpvUuid) {
    final updated = state.products.where((p) => p.seller?.uuid != cpvUuid).toList();
    emit(state.copyWith(products: updated));
  }

  void onWishlistIdsChanged(Set<String> wishlistIds) {
    if (state.status is! StateStatusSuccess) return;

    final currentUuids = state.products.map((p) => p.seller?.uuid).whereType<String>().toSet();

    // Remove products no longer in wishlist
    final updated = state.products.where((p) {
      final uuid = p.seller?.uuid;
      return uuid != null && wishlistIds.contains(uuid);
    }).toList();

    final hasRemovals = updated.length != state.products.length;
    final hasAdditions = wishlistIds.any((id) => !currentUuids.contains(id));

    if (hasRemovals) {
      emit(state.copyWith(products: updated));
    }

    if (hasAdditions) {
      refresh();
    }
  }
}
