import 'dart:async';

import 'package:carfy/domain/use_cases/auth/check_phone_otp_use_case.dart';
import 'package:carfy/domain/use_cases/auth/send_phone_otp_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/check_phone_otp_params.dart';
import 'package:carfy/domain/params/auth/send_phone_otp_params.dart';

part 'phone_verify_otp_state.dart';

class PhoneVerifyOtpCubit extends Cubit<PhoneVerifyOtpState> with StateMapHelper {
  final CheckPhoneOtpUseCase _checkPhoneOtpUseCase;
  final SendPhoneRegisterOtpUseCase _sendPhoneRegisterOtpUseCase;
  final AppRouter _appRouter;

  final TextEditingController otpController = TextEditingController();
  Timer? _timer;

  PhoneVerifyOtpCubit({
    CheckPhoneOtpUseCase? checkPhoneOtpUseCase,
    SendPhoneRegisterOtpUseCase? sendPhoneRegisterOtpUseCase,
    AppRouter? appRouter,
  }) : _checkPhoneOtpUseCase = checkPhoneOtpUseCase ?? getIt<CheckPhoneOtpUseCase>(),
       _sendPhoneRegisterOtpUseCase = sendPhoneRegisterOtpUseCase ?? getIt<SendPhoneRegisterOtpUseCase>(),
       _appRouter = appRouter ?? getIt<AppRouter>(),
       super(PhoneVerifyOtpState.initial()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(timeRemaining: 180, isTimerActive: true));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        emit(state.copyWith(timeRemaining: state.timeRemaining - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(isTimerActive: false));
      }
    });
  }

  void resendOtp(String phone) async {
    _startTimer();
    await _sendPhoneRegisterOtpUseCase(SendPhoneOtpParams(phone: phone));
  }

  Future<void> verify(String phone) async {
    final otp = otpController.text;
    if (otp.length == 4) {
      verifyWithOtp(phone, otp);
    }
  }

  Future<void> verifyWithOtp(String phone, String otpStr) async {
    emit(state.copyWith(verifyState: StateStatus.loading()));

    int otp = int.parse(otpStr);
    final result = await _checkPhoneOtpUseCase(CheckPhoneOtpParams(phone: phone, otp: otp));

    result.fold(
      (failure) {
        emit(state.copyWith(verifyState: mapFailure(failure)));
      },
      (success) {
        emit(state.copyWith(verifyState: StateStatus.success()));
        _appRouter.replace(
          CompletePhoneRegisterRoute(phone: phone, confirmationToken: success.phoneConfirmationToken, otp: otp),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    otpController.dispose();
    return super.close();
  }
}
