import 'dart:async';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/use_cases/auth/change_email_send_otp_use_case.dart';
import 'package:carfy/domain/use_cases/auth/change_email_verify_use_case.dart';
import 'package:carfy/domain/use_cases/auth/change_phone_send_otp_use_case.dart';
import 'package:carfy/domain/use_cases/auth/change_phone_verify_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_contact_state.dart';

class ChangeContactCubit extends Cubit<ChangeContactState> with StateMapHelper {
  final ChangeEmailSendOtpUseCase _changeEmailSendOtp;
  final ChangeEmailVerifyUseCase _changeEmailVerify;
  final ChangePhoneSendOtpUseCase _changePhoneSendOtp;
  final ChangePhoneVerifyUseCase _changePhoneVerify;

  Timer? _expiryTimer;
  Timer? _resendTimer;

  ChangeContactCubit({
    required ChangeContactType type,
    ChangeEmailSendOtpUseCase? changeEmailSendOtp,
    ChangeEmailVerifyUseCase? changeEmailVerify,
    ChangePhoneSendOtpUseCase? changePhoneSendOtp,
    ChangePhoneVerifyUseCase? changePhoneVerify,
  }) : _changeEmailSendOtp = changeEmailSendOtp ?? getIt<ChangeEmailSendOtpUseCase>(),
       _changeEmailVerify = changeEmailVerify ?? getIt<ChangeEmailVerifyUseCase>(),
       _changePhoneSendOtp = changePhoneSendOtp ?? getIt<ChangePhoneSendOtpUseCase>(),
       _changePhoneVerify = changePhoneVerify ?? getIt<ChangePhoneVerifyUseCase>(),
       super(ChangeContactState.initial(type));

  Future<void> sendOtp(String value) async {
    emit(state.copyWith(sendOtpStatus: StateStatus.loading(), value: value));

    final result = state.type == ChangeContactType.email
        ? await _changeEmailSendOtp(value)
        : await _changePhoneSendOtp(value);

    result.fold(
      (failure) => emit(state.copyWith(sendOtpStatus: mapFailure(failure))),
      (response) {
        emit(
          state.copyWith(
            sendOtpStatus: StateStatus.success(),
            step: ChangeContactStep.otp,
            timeRemaining: response.otpExpiresIn,
            isTimerActive: true,
          ),
        );
        _startExpiryTimer(response.otpExpiresIn);
        _startResendCooldown();
      },
    );
  }

  Future<void> verify(String otpStr) async {
    final otp = int.tryParse(otpStr);
    if (otp == null) return;

    emit(state.copyWith(verifyStatus: StateStatus.loading()));

    final result = state.type == ChangeContactType.email
        ? await _changeEmailVerify(state.value, otp)
        : await _changePhoneVerify(state.value, otp);

    result.fold(
      (failure) => emit(state.copyWith(verifyStatus: mapFailure(failure))),
      (user) => emit(state.copyWith(verifyStatus: StateStatus.success(), updatedUser: user)),
    );
  }

  Future<void> resendOtp() async {
    if (!state.canResend) return;
    await sendOtp(state.value);
  }

  void goBackToInput() {
    _expiryTimer?.cancel();
    _resendTimer?.cancel();
    emit(
      state.copyWith(
        step: ChangeContactStep.input,
        sendOtpStatus: StateStatus.initial(),
        verifyStatus: StateStatus.initial(),
      ),
    );
  }

  void _startExpiryTimer(int seconds) {
    _expiryTimer?.cancel();
    emit(state.copyWith(timeRemaining: seconds, isTimerActive: true));

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        emit(state.copyWith(timeRemaining: state.timeRemaining - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(isTimerActive: false));
      }
    });
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    emit(state.copyWith(resendCooldown: 60, canResend: false));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCooldown > 0) {
        emit(state.copyWith(resendCooldown: state.resendCooldown - 1));
      } else {
        timer.cancel();
        emit(state.copyWith(canResend: true));
      }
    });
  }

  @override
  Future<void> close() {
    _expiryTimer?.cancel();
    _resendTimer?.cancel();
    return super.close();
  }
}
