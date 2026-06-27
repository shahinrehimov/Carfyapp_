import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:carfy/domain/params/notifications/notifications_load_params.dart';
import 'package:carfy/domain/use_cases/notifications/delete_all_notifications_use_case.dart';
import 'package:carfy/domain/use_cases/notifications/delete_notification_use_case.dart';
import 'package:carfy/domain/use_cases/notifications/load_notifications_use_case.dart';
import 'package:carfy/domain/use_cases/notifications/read_all_notifications_use_case.dart';
import 'package:carfy/domain/use_cases/notifications/read_notification_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> with StateMapHelper {
  final LoadNotificationsUseCase _loadNotificationsUseCase;
  final ReadNotificationUseCase _readNotificationUseCase;
  final ReadAllNotificationsUseCase _readAllNotificationsUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase _deleteAllNotificationsUseCase;
  final PaginationHelper _paginationHelper = PaginationHelper();

  NotificationsCubit({
    LoadNotificationsUseCase? loadNotificationsUseCase,
    ReadNotificationUseCase? readNotificationUseCase,
    ReadAllNotificationsUseCase? readAllNotificationsUseCase,
    DeleteNotificationUseCase? deleteNotificationUseCase,
    DeleteAllNotificationsUseCase? deleteAllNotificationsUseCase,
  }) : _loadNotificationsUseCase = loadNotificationsUseCase ?? getIt<LoadNotificationsUseCase>(),
       _readNotificationUseCase = readNotificationUseCase ?? getIt<ReadNotificationUseCase>(),
       _readAllNotificationsUseCase = readAllNotificationsUseCase ?? getIt<ReadAllNotificationsUseCase>(),
       _deleteNotificationUseCase = deleteNotificationUseCase ?? getIt<DeleteNotificationUseCase>(),
       _deleteAllNotificationsUseCase = deleteAllNotificationsUseCase ?? getIt<DeleteAllNotificationsUseCase>(),
       super(NotificationsState.initial());

  Future<void> init() async {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (!_paginationHelper.shouldLoad()) return;

    emit(state.copyWith(status: _paginationHelper.getLoadingStatus()));
    _paginationHelper.onLoadStart();

    final result = await _loadNotificationsUseCase(NotificationsLoadParams(page: _paginationHelper.currentPage));
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (response) {
      _paginationHelper.onLoadEnd(response.lastPage);
      final updated = [...state.notifications, ...response.data];
      emit(
        state.copyWith(status: updated.isEmpty ? StateStatus.empty() : StateStatus.success(), notifications: updated),
      );
    });
  }

  Future<void> loadNextPage() async {
    await _loadNotifications();
  }

  Future<void> refresh() async {
    _paginationHelper.reset();
    if (!_paginationHelper.shouldLoad()) return;
    _paginationHelper.onLoadStart();

    final result = await _loadNotificationsUseCase(NotificationsLoadParams(page: _paginationHelper.currentPage));
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (response) {
      _paginationHelper.onLoadEnd(response.lastPage);
      emit(
        state.copyWith(
          status: response.data.isEmpty ? StateStatus.empty() : StateStatus.success(),
          notifications: response.data,
        ),
      );
    });
  }

  Future<void> readNotification(int id) async {
    final result = await _readNotificationUseCase(id);
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (_) {
      final updated = state.notifications.map((n) {
        if (n.id == id) {
          return AppNotification(
            id: n.id,
            uuid: n.uuid,
            title: n.title,
            body: n.body,
            image: n.image,
            actionType: n.actionType,
            actionId: n.actionId,
            isRead: true,
            date: n.date,
            dateRaw: n.dateRaw,
          );
        }
        return n;
      }).toList();
      emit(state.copyWith(notifications: updated));
    });
  }

  Future<void> readAllNotifications() async {
    final result = await _readAllNotificationsUseCase();
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (_) {
      final updated = state.notifications.map((n) {
        return AppNotification(
          id: n.id,
          uuid: n.uuid,
          title: n.title,
          body: n.body,
          image: n.image,
          actionType: n.actionType,
          actionId: n.actionId,
          isRead: true,
          date: n.date,
          dateRaw: n.dateRaw,
        );
      }).toList();
      emit(state.copyWith(notifications: updated));
    });
  }

  Future<void> deleteNotification(int id) async {
    final result = await _deleteNotificationUseCase(id);
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (_) {
      final updated = state.notifications.where((n) => n.id != id).toList();
      emit(
        state.copyWith(notifications: updated, status: updated.isEmpty ? StateStatus.empty() : StateStatus.success()),
      );
    });
  }

  Future<void> deleteAllNotifications() async {
    final result = await _deleteAllNotificationsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (_) => emit(state.copyWith(notifications: [], status: StateStatus.empty())),
    );
  }
}
