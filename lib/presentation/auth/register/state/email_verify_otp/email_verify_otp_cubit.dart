import 'dart:async';

import 'package:carfy/domain/params/auth/verify_email_otp_params.dart';
import 'package:carfy/domain/use_cases/auth/verify_email_otp_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/di/di.dart';
import '../../../../../common/router/app_router.dart';
import '../../../../../common/state/state_map_helper.dart';
import '../../../../../common/state/state_status.dart';

part 'email_verify_otp_state.dart';

class EmailVerifyOtpCubit extends Cubit<EmailVerifyOtpState> with StateMapHelper {
  final VerifyEmailOtpUseCase _verifyEmailOtpUseCase;
  final AppRouter _appRouter;

  final TextEditingController otpController = TextEditingController();

  EmailVerifyOtpCubit({VerifyEmailOtpUseCase? verifyEmailOtpUseCase, AppRouter? appRouter})
    : _verifyEmailOtpUseCase = verifyEmailOtpUseCase ?? getIt<VerifyEmailOtpUseCase>(),
      _appRouter = appRouter ?? getIt<AppRouter>(),
      super(EmailVerifyOtpState.initial());

  Future<void> verify(String email, String userUuid) async {
    final otp = otpController.text;
    if (otp.length == 4) {
      verifyWithOtp(email, otp, userUuid);
    }
  }

  Future<void> verifyWithOtp(String email, String otpStr, String userUuid) async {
    emit(state.copyWith(verifyState: StateStatus.loading()));

    int otp = int.parse(otpStr);
    final result = await _verifyEmailOtpUseCase(VerifyEmailOtpParams(userUuid: userUuid, email: email, otp: otp));

    result.fold(
      (failure) {
        emit(state.copyWith(verifyState: mapFailure(failure)));
      },
      (success) {
        emit(state.copyWith(verifyState: StateStatus.success()));
        _appRouter.replace(RegisteredSuccessfullyRoute());
      },
    );
  }

  @override
  Future<void> close() {
    otpController.dispose();
    return super.close();
  }
}
