import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:carfy/presentation/app/state/wishlist_manager/wishlist_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketManagerListener extends StatefulWidget {
  final Widget child;

  const BasketManagerListener({super.key, required this.child});

  @override
  State<BasketManagerListener> createState() => _BasketManagerListenerState();
}

class _BasketManagerListenerState extends State<BasketManagerListener> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistManagerCubit>().loadWishlistIds();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Basket: per-product action results
        BlocListener<BasketManagerCubit, BasketManagerState>(
          listenWhen: (prev, curr) {
            if (prev.productLoadingStates == curr.productLoadingStates) return false;
            return curr.productLoadingStates.values.any((s) =>
                s is StateStatusFailure ||
                s is StateStatusServerFailure ||
                s is StateStatusNetworkFailure ||
                s is StateStatusSuccessWithMessage);
          },
          listener: (context, state) {
            final keysToRemove = <String>[];
            for (final entry in state.productLoadingStates.entries) {
              final status = entry.value;
              if (status is StateStatusFailure ||
                  status is StateStatusServerFailure ||
                  status is StateStatusNetworkFailure ||
                  status is StateStatusSuccessWithMessage) {
                showStateStatusToast(context, status);
                keysToRemove.add(entry.key);
              }
            }
            if (keysToRemove.isNotEmpty) {
              context.read<BasketManagerCubit>().clearProductStates(keysToRemove);
            }
          },
        ),
        // Basket: basket-level action status
        BlocListener<BasketManagerCubit, BasketManagerState>(
          listenWhen: (prev, curr) => prev.basketActionStatus != curr.basketActionStatus,
          listener: (context, state) {
            final status = state.basketActionStatus;
            if (status is StateStatusFailure ||
                status is StateStatusServerFailure ||
                status is StateStatusNetworkFailure ||
                status is StateStatusSuccessWithMessage) {
              showStateStatusToast(context, status);
              context.read<BasketManagerCubit>().clearBasketActionStatus();
            } else if (status is StateStatusSuccess) {
              context.read<BasketManagerCubit>().clearBasketActionStatus();
            }
          },
        ),
        // Wishlist: error handling
        BlocListener<WishlistManagerCubit, WishlistManagerState>(
          listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
          listener: (context, state) {
            final status = state.actionStatus;
            if (status is StateStatusFailure ||
                status is StateStatusServerFailure ||
                status is StateStatusNetworkFailure) {
              showStateStatusToast(context, status);
              context.read<WishlistManagerCubit>().clearActionStatus();
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
