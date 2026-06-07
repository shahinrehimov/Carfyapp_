import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/order_confirm/state/order_confirm_cubit.dart';
import 'package:carfy/presentation/order_confirm/ui/widget/address_picker_bottom_sheet.dart';
import 'package:carfy/presentation/order_confirm/ui/widget/order_confirm_widgets.dart';
import 'package:carfy/presentation/order_confirm/ui/widget/payment_details_bar.dart';
import 'package:carfy/presentation/order_confirm/ui/widget/seller_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrderConfirmPage extends StatelessWidget implements AutoRouteWrapper {
  const OrderConfirmPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderConfirmCubit()..load(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(title: context.localization.orderConfirmTitle),
      body: MultiBlocListener(
        listeners: [
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) => prev.previewStatus != curr.previewStatus,
            listener: (context, state) => showStateStatusToast(context, state.previewStatus),
          ),
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) => prev.addressesStatus != curr.addressesStatus,
            listener: (context, state) => showStateStatusToast(context, state.addressesStatus),
          ),
          BlocListener<OrderConfirmCubit, OrderConfirmState>(
            listenWhen: (prev, curr) => prev.checkoutStatus != curr.checkoutStatus,
            listener: _handleCheckoutStatus,
          ),
        ],
        child: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
          builder: (context, state) => _OrderConfirmContent(state: state),
        ),
      ),
      bottomNavigationBar: BlocBuilder<OrderConfirmCubit, OrderConfirmState>(
        buildWhen: (prev, curr) =>
            prev.preview != curr.preview ||
            prev.previewStatus != curr.previewStatus ||
            prev.checkoutStatus != curr.checkoutStatus ||
            prev.selectedAddress != curr.selectedAddress ||
            prev.selectedPaymentMethod != curr.selectedPaymentMethod ||
            prev.useReferralBalance != curr.useReferralBalance,
        builder: (context, state) {
          if (state.preview == null) return const SizedBox.shrink();
          return PaymentDetailsBar(
            preview: state.preview!,
            useReferralBalance: state.useReferralBalance,
            isLoading: state.checkoutStatus is StateStatusLoading,
            isPreviewLoading: state.previewStatus is StateStatusLoading,
            canCheckout: state.selectedAddress != null && state.selectedPaymentMethod != null,
            onCheckout: () {
              if (state.selectedAddress == null) {
                showStateStatusToast(context, StateStatus.failure(context.localization.orderConfirmAddressRequired));
                return;
              }
              context.read<OrderConfirmCubit>().checkout();
            },
          );
        },
      ),
    );
  }

  Future<void> _handleCheckoutStatus(BuildContext context, OrderConfirmState state) async {
    final status = state.checkoutStatus;
    showStateStatusToast(context, status);
    if (status is! StateStatusSuccess) return;

    final result = state.checkoutResult;
    final preview = state.preview;
    final address = state.selectedAddress;
    if (result == null || preview == null || address == null) return;

    if (result.requiresWebviewPayment) {
      final paid = await context.router.push<bool>(
        PaymentWebviewRoute(redirectUrl: result.redirectUrl!),
      );
      if (!context.mounted) return;
      if (paid == true) {
        await context.router.replaceAll([const MainRoute(), OrderSuccessRoute(preview: preview, address: address)]);
      } else {
        showStateStatusToast(context, StateStatus.failure(context.localization.paymentFailed));
        context.read<OrderConfirmCubit>().resetCheckoutStatus();
      }
    } else {
      await context.router.replaceAll([const MainRoute(), OrderSuccessRoute(preview: preview, address: address)]);
    }
  }
}

class _OrderConfirmContent extends StatelessWidget {
  final OrderConfirmState state;

  const _OrderConfirmContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        if (state.previewStatus is StateStatusLoading)
          const ItemsShimmer()
        else if (state.preview != null)
          for (int i = 0; i < state.preview!.sellers.length; i++) ...[
            SellerCard(seller: state.preview!.sellers[i]),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 4),
        if (state.addressesStatus is StateStatusLoading)
          const AddressShimmer()
        else
          OrderConfirmAddressCard(
            selectedAddress: state.selectedAddress,
            onTap: () async {
              final picked = await showAddressPickerBottomSheet(context, selectedAddress: state.selectedAddress);
              if (picked != null && context.mounted) {
                context.read<OrderConfirmCubit>().selectAddress(picked);
              }
            },
          ),
        const SizedBox(height: 20),
        if (state.paymentMethodsStatus is StateStatusLoading)
          const PaymentMethodsShimmer()
        else if (state.paymentMethods.isNotEmpty)
          PaymentMethodsSection(
            methods: state.paymentMethods,
            selected: state.selectedPaymentMethod,
            onSelected: (method) => context.read<OrderConfirmCubit>().selectPaymentMethod(method),
          ),
        const SizedBox(height: 20),
        NoteSection(
          initialNote: state.note,
          onChanged: (value) => context.read<OrderConfirmCubit>().setNote(value),
        ),
      ],
    );
  }
}
