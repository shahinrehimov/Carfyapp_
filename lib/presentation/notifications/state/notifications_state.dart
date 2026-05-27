part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final StateStatus status;
  final List<AppNotification> notifications;

  const NotificationsState({
    required this.status,
    required this.notifications,
  });

  factory NotificationsState.initial() => NotificationsState(
        status: StateStatus.loading(),
        notifications: [],
      );

  NotificationsState copyWith({
    StateStatus? status,
    List<AppNotification>? notifications,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [status, notifications];
}
