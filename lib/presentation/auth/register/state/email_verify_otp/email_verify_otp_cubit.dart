import 'dart:async';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/verify_email_otp_params.dart';
import 'package:carfy/domain/use_cases/auth/verify_email_otp_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_map_helper.dart';

part 'email_verify_otp_state.dart';

class EmailVerifyOtpCubit extends Cubit<EmailVerifyOtpState> with StateMapHelper {
  final VerifyEmailOtpUseCase _verifyEmailOtpUseCase;
  final AppRouter _appRouter;

  final TextEditingController otpController = TextEditingController();
  Timer? _rateLimitTimer;

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
        final status = mapFailure(failure);
        emit(state.copyWith(verifyState: status));
        if (status is StateStatusBlockedFailure) {
          otpController.clear();
          _startRateLimitCountdown(status.seconds);
        }
      },
      (success) {
        emit(state.copyWith(verifyState: StateStatus.success()));
        _appRouter.replace(const RegisteredSuccessfullyRoute());
      },
    );
  }

  void _startRateLimitCountdown(int seconds) {
    _rateLimitTimer?.cancel();
    _rateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) { timer.cancel(); return; }
      final current = state.verifyState;
      if (current is! StateStatusBlockedFailure) { timer.cancel(); return; }
      final remaining = current.seconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(verifyState: StateStatus.initial()));
      } else {
        emit(state.copyWith(verifyState: StateStatus.blockedFailure(remaining)));
      }
    });
  }

  @override
  Future<void> close() {
    _rateLimitTimer?.cancel();
    otpController.dispose();
    return super.close();
  }
}
