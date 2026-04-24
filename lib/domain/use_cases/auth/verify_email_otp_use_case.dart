import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/verify_otp_response.dart';
import 'package:carfy/domain/params/auth/verify_email_otp_params.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';

@injectable
class VerifyEmailOtpUseCase {
  final AuthRepository _repository;
  VerifyEmailOtpUseCase(this._repository);

  Future<Either<Failure, VerifyOtpResponse>> call(VerifyEmailOtpParams params) async {
    return await _repository.verifyEmailOtp(params: params);
  }
}
