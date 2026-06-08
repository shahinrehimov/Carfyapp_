import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUnreadCountUseCase {
  final NotificationRepository _repository;

  GetUnreadCountUseCase(this._repository);

  Future<Either<Failure, int>> call() => _repository.getUnreadCount();
}
