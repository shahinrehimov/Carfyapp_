import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/change_contact_otp_response.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePhoneSendOtpUseCase {
  final AuthRepository _repository;

  ChangePhoneSendOtpUseCase(this._repository);

  Future<Either<Failure, ChangeContactOtpResponse>> call(String phone) =>
      _repository.changePhoneSendOtp(phone);
}
