part of 'email_verify_otp_cubit.dart';

class EmailVerifyOtpState {
  final StateStatus verifyState;

  EmailVerifyOtpState({required this.verifyState});

  factory EmailVerifyOtpState.initial() {
    return EmailVerifyOtpState(verifyState: StateStatus.initial());
  }

  EmailVerifyOtpState copyWith({StateStatus? verifyState}) {
    return EmailVerifyOtpState(verifyState: verifyState ?? this.verifyState);
  }
}
