import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:carfy/domain/params/notifications/notifications_load_params.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepository {
  Future<Either<Failure, PaginationResponse<AppNotification>>> loadNotifications(NotificationsLoadParams params);
  Future<Either<Failure, String>> readNotification(int id);
  Future<Either<Failure, String>> readAllNotifications();
  Future<Either<Failure, String>> deleteNotification(int id);
  Future<Either<Failure, String>> deleteAllNotifications();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> registerDeviceToken(String token, String deviceType);
}
