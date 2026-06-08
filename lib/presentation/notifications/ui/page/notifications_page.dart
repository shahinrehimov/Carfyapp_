import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/common/widgets/pagination_scroll_wrapper.dart';
import 'package:carfy/common/widgets/pull_to_refresh_wrapper.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/common/widgets/confirmation_dialog.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:carfy/presentation/notifications/state/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../widget/notification_item.dart';

@RoutePage()
class NotificationsPage extends StatelessWidget implements AutoRouteWrapper {
  const NotificationsPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => NotificationsCubit()..init(),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const _NotificationsAppBar(),
      body: SafeArea(
        child: BlocListener<NotificationsCubit, NotificationsState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) => showStateStatusToast(context, state.status),
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              return state.status.maybeWhen(
                loading: () => const _NotificationsShimmer(),
                empty: () => const _EmptyNotificationsView(),
                orElse: () => _NotificationsList(
                  notifications: state.notifications,
                  isPaginationLoading: state.status is StateStatusPaginationLoading,
                  onLoadMore: () => context.read<NotificationsCubit>().loadNextPage(),
                  onRefresh: () => context.read<NotificationsCubit>().refresh(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<AppNotification> notifications;
  final bool isPaginationLoading;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const _NotificationsList({
    required this.notifications,
    required this.isPaginationLoading,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(notifications);

    return PullToRefreshWrapper(
      onRefresh: onRefresh,
      child: PaginationScrollWrapper(
        onLoadMore: onLoadMore,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < grouped.length; i++) ...[
                if (i > 0) const SizedBox(height: 30),
                _DateGroup(
                  dateLabel: grouped[i].key,
                  notifications: grouped[i].value,
                ),
              ],
              if (isPaginationLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<MapEntry<String, List<AppNotification>>> _groupByDate(List<AppNotification> notifications) {
    final Map<String, List<AppNotification>> grouped = {};
    for (final n in notifications) {
      final dateKey = _formatDateLabel(n.dateRaw);
      grouped.putIfAbsent(dateKey, () => []).add(n);
    }
    return grouped.entries.toList();
  }

  static const _azMonths = [
    'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'İyun',
    'İyul', 'Avqust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr',
  ];

  String _formatDateLabel(String dateRaw) {
    try {
      final date = DateTime.parse(dateRaw);
      return '${date.day} ${_azMonths[date.month - 1]}';
    } catch (_) {
      return dateRaw.split('T').first;
    }
  }
}

class _DateGroup extends StatelessWidget {
  final String dateLabel;
  final List<AppNotification> notifications;

  const _DateGroup({required this.dateLabel, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3.68,
              height: 20,
              decoration: ShapeDecoration(
                color: context.theme.colors.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              dateLabel,
              style: const TextStyle(
                color: Color(0xFF292929),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0.24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...notifications.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _NotificationItem(notification: n),
            )),
      ],
    );
  }
}

class _NotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _NotificationsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      buildWhen: (prev, curr) => prev.notifications != curr.notifications,
      builder: (context, state) {
        final unread = state.notifications.where((n) => !n.isRead).length;
        return CustomAppBarWhite(
          title: unread > 0
              ? '${context.localization.notificationsTitle} ($unread)'
              : context.localization.notificationsTitle,
          actions: [
            _ReadAllButton(),
            _DeleteAllButton(),
          ],
        );
      },
    );
  }
}

class _ReadAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showConfirmationDialog(
        context: context,
        title: context.localization.notificationsReadAll,
        description: context.localization.notificationsReadAllConfirm,
        confirmText: context.localization.notificationsReadAll,
        cancelText: context.localization.cancel,
        onConfirm: () => context.read<NotificationsCubit>().readAllNotifications(),
      ),
      icon: Icon(Icons.done_all_rounded, size: 22, color: context.theme.colors.primary),
    );
  }
}

class _DeleteAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showConfirmationDialog(
        context: context,
        title: context.localization.notificationsDeleteAll,
        description: context.localization.notificationsDeleteAllConfirm,
        confirmText: context.localization.notificationsDeleteAll,
        cancelText: context.localization.cancel,
        onConfirm: () => context.read<NotificationsCubit>().deleteAllNotifications(),
      ),
      icon: const Icon(Icons.delete_outline_rounded, size: 22, color: Color(0xFFF44336)),
    );
  }
}

class _EmptyNotificationsView extends StatelessWidget {
  const _EmptyNotificationsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.images.messageNotLogged.path, height: 168),
          const SizedBox(height: 16),
          Text(
            context.localization.notificationsEmpty,
            style: TextStyle(fontSize: 18, color: context.theme.colors.black),
          ),
        ],
      ),
    );
  }
}

class _NotificationsShimmer extends StatelessWidget {
  const _NotificationsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) => ShimmerWrapper(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: context.theme.colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
