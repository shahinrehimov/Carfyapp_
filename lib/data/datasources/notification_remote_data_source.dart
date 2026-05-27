import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/notifications/notifications_load_query_params.dart';
import 'package:carfy/data/models/notifications/app_notification_model.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationRemoteDataSource {
  Future<PaginationResponseModel<AppNotificationModel>> loadNotifications(NotificationsLoadQueryParams params);
  Future<String> readNotification(int id);
  Future<String> readAllNotifications();
  Future<String> deleteNotification(int id);
  Future<String> deleteAllNotifications();
}

@Injectable(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<PaginationResponseModel<AppNotificationModel>> loadNotifications(NotificationsLoadQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.notificationsLoad, queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => AppNotificationModel.fromJson(item)),
    );
  }

  @override
  Future<String> readNotification(int id) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.notificationRead(id)),
      map: (json) => json['message'] as String,
    );
  }

  @override
  Future<String> readAllNotifications() {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.notificationsReadAll),
      map: (json) => json['message'] as String,
    );
  }

  @override
  Future<String> deleteNotification(int id) {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.notificationDelete(id)),
      map: (json) => json['message'] as String,
    );
  }

  @override
  Future<String> deleteAllNotifications() {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.notificationsDeleteAll),
      map: (json) => json['message'] as String,
    );
  }
}
