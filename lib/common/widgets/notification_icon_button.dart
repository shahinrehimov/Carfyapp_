import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/notification_badge_cubit.dart';
import 'package:carfy/common/state/notification_icon/notification_icon_cubit.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationIconCubit()..load(),
      child: const _NotificationIconButtonView(),
    );
  }
}

class _NotificationIconButtonView extends StatelessWidget {
  const _NotificationIconButtonView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationIconCubit, bool>(
      builder: (context, isAuthenticated) {
        if (!isAuthenticated) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () async {
            await context.pushRoute(const NotificationsRoute());
            if (context.mounted) {
              context.read<NotificationBadgeCubit>().load();
            }
          },
          child: BlocBuilder<NotificationBadgeCubit, int>(
            builder: (context, count) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 5), child: SvgPicture.asset(Assets.icons.notification)),
                  if (count > 0)
                    Positioned(
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFF44336), borderRadius: BorderRadius.circular(8)),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        alignment: Alignment.center,
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
