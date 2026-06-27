import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_toast.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/orders/order_detail.dart';
import 'package:carfy/presentation/order_detail/state/order_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../widget/order_info_card.dart';
part '../widget/order_products_section.dart';
part '../widget/order_payment_section.dart';
part '../widget/order_address_section.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget implements AutoRouteWrapper {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => OrderDetailCubit()..init(orderId), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomAppBarWhite(title: context.localization.orderDetailTitle),
      body: BlocListener<OrderDetailCubit, OrderDetailState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) => showStateStatusToast(context, state.status),
        child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
          builder: (context, state) {
            return state.status.maybeWhen(
              loading: () => const _OrderDetailShimmer(),
              orElse: () {
                final order = state.order;
                if (order == null) return const SizedBox.shrink();
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _OrderInfoCard(order: order),
                      const SizedBox(height: 16),
                      _OrderProductsSection(items: order.items),
                      const SizedBox(height: 16),
                      _OrderPaymentSection(paymentMethod: order.paymentMethod),
                      const SizedBox(height: 16),
                      _OrderAddressSection(address: order.address),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _OrderDetailShimmer extends StatelessWidget {
  const _OrderDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerWrapper(
            child: Container(
              height: 140,
              decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
