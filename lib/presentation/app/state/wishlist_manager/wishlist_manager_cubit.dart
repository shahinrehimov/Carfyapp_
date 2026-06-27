import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/use_cases/wishlist/add_to_wishlist_use_case.dart';
import 'package:carfy/domain/use_cases/wishlist/get_wishlist_ids_use_case.dart';
import 'package:carfy/domain/use_cases/wishlist/remove_from_wishlist_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wishlist_manager_state.dart';

class WishlistManagerCubit extends Cubit<WishlistManagerState> with StateMapHelper {
  final GetWishlistIdsUseCase _getWishlistIdsUseCase;
  final AddToWishlistUseCase _addToWishlistUseCase;
  final RemoveFromWishlistUseCase _removeFromWishlistUseCase;

  WishlistManagerCubit({
    GetWishlistIdsUseCase? getWishlistIdsUseCase,
    AddToWishlistUseCase? addToWishlistUseCase,
    RemoveFromWishlistUseCase? removeFromWishlistUseCase,
  }) : _getWishlistIdsUseCase = getWishlistIdsUseCase ?? getIt<GetWishlistIdsUseCase>(),
       _addToWishlistUseCase = addToWishlistUseCase ?? getIt<AddToWishlistUseCase>(),
       _removeFromWishlistUseCase = removeFromWishlistUseCase ?? getIt<RemoveFromWishlistUseCase>(),
       super(WishlistManagerState.initial());

  Future<void> loadWishlistIds() async {
    final result = await _getWishlistIdsUseCase();
    result.fold((_) {}, (ids) => emit(state.copyWith(wishlistIds: ids.toSet())));
  }

  bool isInWishlist(String cpvUuid) => state.wishlistIds.contains(cpvUuid);

  Future<void> toggle(String cpvUuid) async {
    if (isInWishlist(cpvUuid)) {
      _remove(cpvUuid);
    } else {
      _add(cpvUuid);
    }
  }

  Future<void> _add(String cpvUuid) async {
    // Optimistic
    final updatedIds = Set<String>.from(state.wishlistIds)..add(cpvUuid);
    emit(state.copyWith(wishlistIds: updatedIds));

    final result = await _addToWishlistUseCase(cpvUuid);
    result.fold((failure) {
      // Rollback
      final rolledBack = Set<String>.from(state.wishlistIds)..remove(cpvUuid);
      emit(state.copyWith(wishlistIds: rolledBack, actionStatus: mapFailure(failure)));
    }, (_) {});
  }

  Future<void> _remove(String cpvUuid) async {
    // Optimistic
    final updatedIds = Set<String>.from(state.wishlistIds)..remove(cpvUuid);
    emit(state.copyWith(wishlistIds: updatedIds));

    final result = await _removeFromWishlistUseCase(cpvUuid);
    result.fold((failure) {
      // Rollback
      final rolledBack = Set<String>.from(state.wishlistIds)..add(cpvUuid);
      emit(state.copyWith(wishlistIds: rolledBack, actionStatus: mapFailure(failure)));
    }, (_) {});
  }

  void clearActionStatus() {
    emit(state.copyWith(actionStatus: StateStatus.initial()));
  }
}
