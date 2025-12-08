part of 'verify_otp_cubit.dart';

class VerifyOtpState {
  final StateStatus verifyState;
  final int timeRemaining;
  final bool isTimerActive;

  VerifyOtpState({required this.verifyState, required this.timeRemaining, required this.isTimerActive});

  factory VerifyOtpState.initial() {
    return VerifyOtpState(verifyState: StateStatus.initial(), timeRemaining: 180, isTimerActive: true);
  }

  VerifyOtpState copyWith({StateStatus? verifyState, int? timeRemaining, bool? isTimerActive}) {
    return VerifyOtpState(
      verifyState: verifyState ?? this.verifyState,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }
}
