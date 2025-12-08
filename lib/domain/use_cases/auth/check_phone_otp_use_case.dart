import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/check_phone_otp_response.dart';
import '../../params/auth/check_phone_otp_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class CheckPhoneOtpUseCase {
  final AuthRepository _repository;
  CheckPhoneOtpUseCase(this._repository);

  Future<Either<Failure, CheckPhoneOtpResponse>> call(CheckPhoneOtpParams params) async {
    return await _repository.checkPhoneOtp(params: params);
  }
}
