import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/send_phone_otp_response.dart';
import '../../params/auth/login_with_phone_otp_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class SendPhoneLoginOtpUseCase {
  final AuthRepository _repository;
  SendPhoneLoginOtpUseCase(this._repository);

  Future<Either<Failure, SendPhoneOtpResponse>> call(LoginWithPhoneOtpParams params) async {
    return await _repository.sendPhoneLoginOtp(params: params);
  }
}
