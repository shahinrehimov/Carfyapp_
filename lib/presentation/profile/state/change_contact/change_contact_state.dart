part of 'change_contact_cubit.dart';

enum ChangeContactType { email, phone }

enum ChangeContactStep { input, otp }

class ChangeContactState extends Equatable {
  final ChangeContactType type;
  final ChangeContactStep step;
  final StateStatus sendOtpStatus;
  final StateStatus verifyStatus;
  final String value;
  final int timeRemaining;
  final bool isTimerActive;
  final int resendCooldown;
  final bool canResend;
  final AuthUser? updatedUser;

  const ChangeContactState({
    required this.type,
    required this.step,
    required this.sendOtpStatus,
    required this.verifyStatus,
    required this.value,
    required this.timeRemaining,
    required this.isTimerActive,
    required this.resendCooldown,
    required this.canResend,
    this.updatedUser,
  });

  factory ChangeContactState.initial(ChangeContactType type) => ChangeContactState(
    type: type,
    step: ChangeContactStep.input,
    sendOtpStatus: StateStatus.initial(),
    verifyStatus: StateStatus.initial(),
    value: '',
    timeRemaining: 0,
    isTimerActive: false,
    resendCooldown: 0,
    canResend: false,
  );

  ChangeContactState copyWith({
    ChangeContactType? type,
    ChangeContactStep? step,
    StateStatus? sendOtpStatus,
    StateStatus? verifyStatus,
    String? value,
    int? timeRemaining,
    bool? isTimerActive,
    int? resendCooldown,
    bool? canResend,
    AuthUser? updatedUser,
  }) => ChangeContactState(
    type: type ?? this.type,
    step: step ?? this.step,
    sendOtpStatus: sendOtpStatus ?? this.sendOtpStatus,
    verifyStatus: verifyStatus ?? this.verifyStatus,
    value: value ?? this.value,
    timeRemaining: timeRemaining ?? this.timeRemaining,
    isTimerActive: isTimerActive ?? this.isTimerActive,
    resendCooldown: resendCooldown ?? this.resendCooldown,
    canResend: canResend ?? this.canResend,
    updatedUser: updatedUser ?? this.updatedUser,
  );

  @override
  List<Object?> get props => [
    type,
    step,
    sendOtpStatus,
    verifyStatus,
    value,
    timeRemaining,
    isTimerActive,
    resendCooldown,
    canResend,
    updatedUser,
  ];
}
