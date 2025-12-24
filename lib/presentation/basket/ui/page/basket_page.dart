import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/dotted_line_painter.dart';
import 'package:carfy/common/widgets/loading_dialog.dart';
import 'package:carfy/common/widgets/pull_to_refresh_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/app/state/basket_manager/basket_manager_cubit.dart';
import 'package:carfy/presentation/basket/state/basket_cubit.dart';
import 'package:carfy/presentation/basket/ui/widget/basket_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class BasketPage extends StatelessWidget implements AutoRouteWrapper {
  const BasketPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => BasketCubit()..init(), child: this);
  }

  @override
  Widget build(BuildContext context) {
    return _BasketManagerListener(
      child: Scaffold(
        backgroundColor: context.theme.colors.bg,
        appBar: CustomAppBar(
          title: context.localization.mainBasket,
          actions: [IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.notification))],
        ),
        body: BlocBuilder<BasketCubit, BasketState>(
          builder: (context, state) {
            return state.basketStatus.maybeWhen(
              success: () => state.items.isNotEmpty
                  ? PullToRefreshWrapper(
                      onRefresh: () async {
                        await context.read<BasketCubit>().refresh();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: state.items.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 24),
                              itemBuilder: (context, index) => BasketItem(basketProduct: state.items[index]),
                            ),
                            Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: context.theme.colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.localization.paymentDetails,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: context.theme.colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                    context,
                                    context.localization.amount,
                                    '${state.basketData!.totalPriceInBasket} ₼',
                                  ),
                                  _buildDetailRow(
                                    context,
                                    context.localization.productCount,
                                    '${state.basketData!.totalBasketQuantity} ${context.localization.piece}',
                                  ),
                                  _buildDetailRow(
                                    context,
                                    context.localization.deliveryFee,
                                    '${state.basketData!.shipping} ₼',
                                  ),
                                  _buildDetailRow(
                                    context,
                                    context.localization.discount,
                                    '${state.basketData!.totalDiscountInBasket} ₼',
                                  ),
                                  _buildDetailRow(
                                    context,
                                    context.localization.total,
                                    '${state.basketData!.totalPriceFinalInBasket} ₼',
                                    isBold: true,
                                  ),
                                  const SizedBox(height: 16),
                                  CustomButton(onPressed: () {}, text: context.localization.formOrder),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: Text('empty')), // TODO
              orElse: () => const _BasketLoading(),
            );
          },
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

class _BasketManagerListener extends StatefulWidget {
  final Widget child;

  const _BasketManagerListener({required this.child});

  @override
  State<_BasketManagerListener> createState() => _BasketManagerListenerState();
}

class _BasketManagerListenerState extends State<_BasketManagerListener> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BasketManagerCubit, BasketManagerState>(
      listenWhen: (previous, current) => previous.basketActionStatus != current.basketActionStatus,
      listener: (context, managerState) {
        final status = managerState.basketActionStatus;

        if (status is StateStatusLoading) {
          _isDialogShowing = true;
          LoadingDialog.show(context);
        } else if (status is StateStatusSuccess || status is StateStatusSuccessWithMessage) {
          if (_isDialogShowing) {
            LoadingDialog.hide(context);
            _isDialogShowing = false;
          }
          context.read<BasketCubit>().refresh();
          context.read<BasketManagerCubit>().clearBasketActionStatus();
        } else if (status is StateStatusFailure ||
            status is StateStatusServerFailure ||
            status is StateStatusNetworkFailure) {
          if (_isDialogShowing) {
            LoadingDialog.hide(context);
            _isDialogShowing = false;
          }
          showStateStatusToast(context, status);
          context.read<BasketManagerCubit>().clearBasketActionStatus();
        }
      },
      child: widget.child,
    );
  }
}
