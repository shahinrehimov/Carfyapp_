import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/send_phone_otp_response.dart';
import 'package:carfy/domain/params/auth/send_phone_otp_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class SendPhoneRegisterOtpUseCase {
  final AuthRepository _repository;
  SendPhoneRegisterOtpUseCase(this._repository);

  Future<Either<Failure, SendPhoneOtpResponse>> call(SendPhoneOtpParams params) async {
    return await _repository.sendPhoneOtp(params: params);
  }
}
