import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/send_phone_otp_response.dart';
import 'package:carfy/domain/params/auth/login_with_phone_otp_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class SendPhoneLoginOtpUseCase {
  final AuthRepository _repository;
  SendPhoneLoginOtpUseCase(this._repository);

  Future<Either<Failure, SendPhoneOtpResponse>> call(LoginWithPhoneOtpParams params) async {
    return await _repository.sendPhoneLoginOtp(params: params);
  }
}
