import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterDeviceTokenUseCase {
  final NotificationRepository _repository;

  RegisterDeviceTokenUseCase(this._repository);

  Future<Either<Failure, void>> call(String token, String deviceType) {
    return _repository.registerDeviceToken(token, deviceType);
  }
}
