import 'dart:async';

import 'package:carfy/common/util/device_util.dart';
import 'package:carfy/domain/params/auth/login_with_phone_submit_params.dart';
import 'package:carfy/domain/use_cases/auth/login_with_phone_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/params/auth/login_with_phone_otp_params.dart';
import 'package:carfy/domain/use_cases/auth/send_phone_login_otp_use_case.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> with StateMapHelper {
  final LoginWithPhoneUseCase _loginWithPhoneUseCase;
  final SendPhoneLoginOtpUseCase _sendPhoneLoginOtpUseCase;
  final AppRouter _appRouter;

  final TextEditingController otpController = TextEditingController();
  Timer? _timer;

  VerifyOtpCubit({
    LoginWithPhoneUseCase? loginWithPhoneUseCase,
    SendPhoneLoginOtpUseCase? sendPhoneLoginOtpUseCase,
    AppRouter? appRouter,
  }) : _loginWithPhoneUseCase = loginWithPhoneUseCase ?? getIt<LoginWithPhoneUseCase>(),
       _sendPhoneLoginOtpUseCase = sendPhoneLoginOtpUseCase ?? getIt<SendPhoneLoginOtpUseCase>(),
       _appRouter = appRouter ?? getIt<AppRouter>(),
       super(VerifyOtpState.initial()) {
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
    await _sendPhoneLoginOtpUseCase(LoginWithPhoneOtpParams(phone: phone));
  }

  Future<void> verify(String phone) async {
    final otp = otpController.text;
    if (otp.length == 4) {
      verifyWithOtp(phone, otp);
    }
  }

  Future<void> verifyWithOtp(String phone, String otp) async {
    emit(state.copyWith(verifyState: StateStatus.loading()));

    final deviceName = await DeviceUtil.getDeviceName();
    final result = await _loginWithPhoneUseCase(LoginWithPhoneSubmitParams(phone: phone, otp: int.parse(otp), deviceName: deviceName));

    result.fold(
      (failure) {
        emit(state.copyWith(verifyState: mapFailure(failure)));
      },
      (success) {
        emit(state.copyWith(verifyState: StateStatus.success()));
        PrefUtil.setString(AppPreferenceKeys.authToken, success.token);
        PrefUtil.remove(AppPreferenceKeys.guestIdentifier);
        _appRouter.replaceAll([const MainRoute()]);
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
