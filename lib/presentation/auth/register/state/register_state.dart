part of 'register_cubit.dart';

class RegisterState {
  final StateStatus checkEmailState;
  final FieldValidationState emailValidationState;
  final StateStatus phoneRegisterState;
  final FieldValidationState phoneValidationState;

  RegisterState({
    required this.checkEmailState,
    required this.emailValidationState,
    required this.phoneRegisterState,
    required this.phoneValidationState,
  });

  factory RegisterState.initial() => RegisterState(
    checkEmailState: StateStatus.initial(),
    emailValidationState: FieldValidationState.pure(),
    phoneRegisterState: StateStatus.initial(),
    phoneValidationState: FieldValidationState.pure(),
  );

  RegisterState copyWith({
    StateStatus? checkEmailState,
    FieldValidationState? emailValidationState,
    StateStatus? phoneRegisterState,
    FieldValidationState? phoneValidationState,
  }) {
    return RegisterState(
      checkEmailState: checkEmailState ?? this.checkEmailState,
      emailValidationState: emailValidationState ?? this.emailValidationState,
      phoneRegisterState: phoneRegisterState ?? this.phoneRegisterState,
      phoneValidationState: phoneValidationState ?? this.phoneValidationState,
    );
  }
}
