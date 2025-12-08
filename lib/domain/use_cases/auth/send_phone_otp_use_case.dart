import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/send_phone_otp_response.dart';
import '../../params/auth/send_phone_otp_params.dart';
import '../../repositories/auth/auth_repository.dart';

@injectable
class SendPhoneOtpUseCase {
  final AuthRepository _repository;
  SendPhoneOtpUseCase(this._repository);

  Future<Either<Failure, SendPhoneOtpResponse>> call(SendPhoneOtpParams params) async {
    return await _repository.sendPhoneOtp(params: params);
  }
}
