import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAllNotificationsUseCase {
  final NotificationRepository _repository;

  DeleteAllNotificationsUseCase(this._repository);

  Future<Either<Failure, String>> call() => _repository.deleteAllNotifications();
}
