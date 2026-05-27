import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadNotificationUseCase {
  final NotificationRepository _repository;

  ReadNotificationUseCase(this._repository);

  Future<Either<Failure, String>> call(int id) => _repository.readNotification(id);
}
