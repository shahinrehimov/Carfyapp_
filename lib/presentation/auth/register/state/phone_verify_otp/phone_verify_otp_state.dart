part of 'phone_verify_otp_cubit.dart';

class PhoneVerifyOtpState {
  final StateStatus verifyState;
  final int timeRemaining;
  final bool isTimerActive;

  PhoneVerifyOtpState({required this.verifyState, required this.timeRemaining, required this.isTimerActive});

  factory PhoneVerifyOtpState.initial() {
    return PhoneVerifyOtpState(verifyState: StateStatus.initial(), timeRemaining: 180, isTimerActive: true);
  }

  PhoneVerifyOtpState copyWith({StateStatus? verifyState, int? timeRemaining, bool? isTimerActive}) {
    return PhoneVerifyOtpState(
      verifyState: verifyState ?? this.verifyState,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }
}
