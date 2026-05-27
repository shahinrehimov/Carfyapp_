import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteNotificationUseCase {
  final NotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<Either<Failure, String>> call(int id) => _repository.deleteNotification(id);
}
