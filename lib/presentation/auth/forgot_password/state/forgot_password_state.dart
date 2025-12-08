part of 'forgot_password_cubit.dart';

class ForgotPasswordState {
  final StateStatus sendOtpState;
  final FieldValidationState emailValidationState;

  ForgotPasswordState({required this.sendOtpState, required this.emailValidationState});

  factory ForgotPasswordState.initial() =>
      ForgotPasswordState(sendOtpState: StateStatus.initial(), emailValidationState: FieldValidationState.pure());

  ForgotPasswordState copyWith({StateStatus? sendOtpState, FieldValidationState? emailValidationState}) {
    return ForgotPasswordState(
      sendOtpState: sendOtpState ?? this.sendOtpState,
      emailValidationState: emailValidationState ?? this.emailValidationState,
    );
  }
}
