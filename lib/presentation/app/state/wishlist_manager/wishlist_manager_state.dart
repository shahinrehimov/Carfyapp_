part of 'wishlist_manager_cubit.dart';

class WishlistManagerState extends Equatable {
  final Set<String> wishlistIds;
  final StateStatus actionStatus;

  const WishlistManagerState({
    required this.wishlistIds,
    required this.actionStatus,
  });

  factory WishlistManagerState.initial() => WishlistManagerState(
    wishlistIds: const {},
    actionStatus: StateStatus.initial(),
  );

  WishlistManagerState copyWith({
    Set<String>? wishlistIds,
    StateStatus? actionStatus,
  }) {
    return WishlistManagerState(
      wishlistIds: wishlistIds ?? this.wishlistIds,
      actionStatus: actionStatus ?? this.actionStatus,
    );
  }

  @override
  List<Object?> get props => [wishlistIds, actionStatus];
}
