import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:carfy/domain/params/notifications/notifications_load_params.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadNotificationsUseCase {
  final NotificationRepository _repository;

  LoadNotificationsUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<AppNotification>>> call(NotificationsLoadParams params) =>
      _repository.loadNotifications(params);
}
