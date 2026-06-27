import 'package:carfy/data/models/notifications/app_notification_model.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationMapper {
  AppNotification mapNotification(AppNotificationModel model) => AppNotification(
    id: model.id,
    uuid: model.uuid,
    title: model.title,
    body: model.body,
    image: model.image,
    actionType: model.actionType,
    actionId: model.actionId,
    isRead: model.isRead,
    date: model.date,
    dateRaw: model.dateRaw,
  );
}
