import 'package:carfy/common/data/mappers/pagination_mapper.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/notification_remote_data_source.dart';
import 'package:carfy/data/dtos/notifications/notifications_load_query_params.dart';
import 'package:carfy/data/mappers/notification_mapper.dart';
import 'package:carfy/domain/entities/notifications/app_notification.dart';
import 'package:carfy/domain/params/notifications/notifications_load_params.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl extends NotificationRepository with RepositorySafeCallMixin {
  final NotificationRemoteDataSource _dataSource;
  final NotificationMapper _mapper;

  NotificationRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, PaginationResponse<AppNotification>>> loadNotifications(NotificationsLoadParams params) {
    return safeCall(() async {
      final res = await _dataSource.loadNotifications(
        NotificationsLoadQueryParams(page: params.page, limit: params.limit),
      );
      return PaginationMapper.map(res, _mapper.mapNotification);
    });
  }

  @override
  Future<Either<Failure, String>> readNotification(int id) {
    return safeCall(() => _dataSource.readNotification(id));
  }

  @override
  Future<Either<Failure, String>> readAllNotifications() {
    return safeCall(() => _dataSource.readAllNotifications());
  }

  @override
  Future<Either<Failure, String>> deleteNotification(int id) {
    return safeCall(() => _dataSource.deleteNotification(id));
  }

  @override
  Future<Either<Failure, String>> deleteAllNotifications() {
    return safeCall(() => _dataSource.deleteAllNotifications());
  }
}
