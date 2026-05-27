import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/orders/order_summary.dart';
import 'package:carfy/presentation/orders/state/orders_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../widget/order_item.dart';

@RoutePage()
class OrdersPage extends StatelessWidget implements AutoRouteWrapper {
  const OrdersPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => OrdersCubit()..init(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: CustomAppBarWhite(title: context.localization.profileMyOrders),
      body: BlocListener<OrdersCubit, OrdersState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) => showStateStatusToast(context, state.status),
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return state.status.maybeWhen(
              loading: () => const _OrdersListShimmer(),
              empty: () => _EmptyOrdersView(),
              orElse: () => _OrdersList(
                orders: state.orders,
                isPaginationLoading: state.status is StateStatusPaginationLoading,
                onLoadMore: () => context.read<OrdersCubit>().loadNextPage(),
                onRefresh: () => context.read<OrdersCubit>().refresh(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<OrderSummary> orders;
  final bool isPaginationLoading;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const _OrdersList({
    required this.orders,
    required this.isPaginationLoading,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length + (isPaginationLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _OrderItem(order: orders[index]);
          },
        ),
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.localization.profileMyOrders,
        style: TextStyle(fontSize: 18, color: context.theme.colors.black),
      ),
    );
  }
}

class _OrdersListShimmer extends StatelessWidget {
  const _OrdersListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: context.theme.colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
