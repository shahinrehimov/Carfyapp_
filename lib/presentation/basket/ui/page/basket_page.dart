import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/extensions/price_extension.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/dotted_line_painter.dart';
import 'package:carfy/common/widgets/pull_to_refresh_wrapper.dart';
import 'package:carfy/common/widgets/notification_icon_button.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:carfy/presentation/app/state/localization/localization_cubit.dart';
import 'package:carfy/presentation/basket/state/basket_cubit.dart';
import 'package:carfy/presentation/basket/ui/widget/basket_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BasketPage extends StatelessWidget implements AutoRouteWrapper {
  const BasketPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => BasketCubit()..init(),
      child: BlocListener<LocalizationCubit, LocalizationState>(
        listenWhen: (prev, curr) => prev.appLanguage != curr.appLanguage,
        listener: (context, _) => context.read<BasketCubit>().init(),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _BasketManagerListener(
      child: Scaffold(
        backgroundColor: context.theme.colors.bg,
        appBar: CustomAppBar(title: context.localization.mainBasket, actions: [const NotificationIconButton()]),
        body: BlocBuilder<BasketCubit, BasketState>(
          builder: (context, state) {
            return state.basketStatus.maybeWhen(
              success: () => state.items.isNotEmpty
                  ? PullToRefreshWrapper(
                      onRefresh: () async {
                        await context.read<BasketCubit>().refresh();
                      },
                      child: ListView.builder(
                        itemCount: state.items.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 24),
                        itemBuilder: (context, index) => BasketItem(basketProduct: state.items[index]),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Assets.images.basketNotLogged.path, height: 168),
                          const SizedBox(height: 16),
                          Text(
                            context.localization.basketEmpty,
                            style: TextStyle(fontSize: 18, color: context.theme.colors.black),
                          ),
                        ],
                      ),
                    ),
              orElse: () => const _BasketLoading(),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BasketCubit, BasketState>(
          builder: (context, state) {
            if (state.basketData == null || state.items.isEmpty) return const SizedBox.shrink();
            return _PaymentDetailsBar(state: state, context: context);
          },
        ),
      ),
    );
  }
}

class _PaymentDetailsBar extends StatelessWidget {
  final BasketState state;
  final BuildContext context;

  const _PaymentDetailsBar({required this.state, required this.context});

  @override
  Widget build(BuildContext _) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, -4))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localization.paymentDetails,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.black),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(context, context.localization.amount, state.basketData!.totalPrice.manatFormatted),
            _buildDetailRow(
              context,
              context.localization.productCount,
              '${state.basketData!.totalItems} ${context.localization.piece}',
            ),
            // _buildDetailRow(context, context.localization.deliveryFee, state.basketData!.shipping.manatFormatted),
            _buildDetailRow(context, context.localization.discount, state.basketData!.totalDiscount.manatFormatted),
            _buildDetailRow(
              context,
              context.localization.total,
              state.basketData!.totalPriceFinal.manatFormatted,
              isBold: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () async {
                await context.pushRoute(const OrderConfirmRoute());
                if (context.mounted) context.read<BasketCubit>().refresh();
              },
              text: context.localization.formOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400,
              color: context.theme.colors.textDark,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 1,
              child: CustomPaint(painter: DottedLinePainter()),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? context.theme.colors.primary : context.theme.colors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _BasketLoading extends StatelessWidget {
  const _BasketLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const BasketLoadingItem(),
    );
  }
}

class _BasketManagerListener extends StatelessWidget {
  final Widget child;

  const _BasketManagerListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Sync server data back to basket state after API responses
        BlocListener<BasketManagerCubit, BasketManagerState>(
          listenWhen: (prev, curr) => curr.quantityUpdate != null && prev.quantityUpdate != curr.quantityUpdate,
          listener: (context, managerState) {
            final update = managerState.quantityUpdate!;
            if (update.quantity <= 0) {
              context.read<BasketCubit>().removeItem(update.cpvUuid, update.basketData);
            } else {
              context.read<BasketCubit>().updateItemQuantity(update.cpvUuid, update.quantity, update.basketData);
            }
          },
        ),
        // Rollback optimistic update on error
        BlocListener<BasketManagerCubit, BasketManagerState>(
          listenWhen: (prev, curr) {
            if (prev.productLoadingStates == curr.productLoadingStates) return false;
            return curr.productLoadingStates.values.any(
              (s) => s is StateStatusFailure || s is StateStatusServerFailure || s is StateStatusNetworkFailure,
            );
          },
          listener: (context, _) {
            context.read<BasketCubit>().rollback();
          },
        ),
        // Refresh basket when add-to-basket succeeds from another page
        BlocListener<BasketManagerCubit, BasketManagerState>(
          listenWhen: (prev, curr) =>
              prev.basketActionStatus != curr.basketActionStatus &&
              (curr.basketActionStatus is StateStatusSuccess ||
                  curr.basketActionStatus is StateStatusSuccessWithMessage),
          listener: (context, _) {
            context.read<BasketCubit>().refresh();
          },
        ),
      ],
      child: child,
    );
  }
}
