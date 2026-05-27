part of '../page/notifications_page.dart';

class _NotificationItem extends StatefulWidget {
  final AppNotification notification;

  const _NotificationItem({required this.notification});

  @override
  State<_NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<_NotificationItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  bool _isOpen = false;

  double get _actionWidth => widget.notification.isRead ? 70 : 140;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final delta = -details.primaryDelta! / _actionWidth;
    _controller.value = (_controller.value + delta).clamp(0.0, 1.0);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.value > 0.5) {
      _controller.forward();
      _isOpen = true;
    } else {
      _controller.reverse();
      _isOpen = false;
    }
  }

  void _close() {
    _controller.reverse();
    _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.notification.isRead)
                    _SwipeAction(
                      color: context.theme.colors.secondary,
                      icon: Icons.done_rounded,
                      label: context.localization.notificationsRead,
                      onTap: () {
                        _close();
                        showConfirmationDialog(
                          context: context,
                          title: context.localization.notificationsRead,
                          description: context.localization.notificationsReadConfirm,
                          confirmText: context.localization.notificationsRead,
                          cancelText: context.localization.cancel,
                          onConfirm: () => cubit.readNotification(widget.notification.id),
                        );
                      },
                    ),
                  _SwipeAction(
                    color: const Color(0xFFF44336),
                    icon: Icons.delete_outline_rounded,
                    label: context.localization.delete,
                    onTap: () {
                      _close();
                      showConfirmationDialog(
                        context: context,
                        title: context.localization.delete,
                        description: context.localization.notificationsDeleteConfirm,
                        confirmText: context.localization.delete,
                        cancelText: context.localization.cancel,
                        onConfirm: () => cubit.deleteNotification(widget.notification.id),
                      );
                    },
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_slideAnimation.value.dx * _actionWidth, 0),
                  child: child,
                );
              },
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                onTap: _isOpen ? _close : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFBFBFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.notification.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                letterSpacing: 0.24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.notification.body,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                letterSpacing: 0.24,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              widget.notification.date,
                              style: const TextStyle(
                                color: Color(0xFF717171),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                                letterSpacing: 0.39,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.notification.isRead) ...[
                        const SizedBox(width: 30),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFDA0E0E),
                            shape: OvalBorder(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeAction extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SwipeAction({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
