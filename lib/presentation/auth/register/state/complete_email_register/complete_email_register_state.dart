part of 'complete_email_register_cubit.dart';

class CompleteEmailRegisterState {
  final bool obscurePassword;
  final bool obscureRepeatPassword;
  final StateStatus registerState;
  final FieldValidationState nameValidationState;
  final FieldValidationState surnameValidationState;
  final FieldValidationState phoneValidationState;
  final FieldValidationState emailValidationState;
  final FieldValidationState passwordValidationState;
  final FieldValidationState repeatPasswordValidationState;
  final Gender? selectedGender;
  final DateTime? selectedBirthDate;

  CompleteEmailRegisterState({
    required this.obscurePassword,
    required this.obscureRepeatPassword,
    required this.registerState,
    required this.nameValidationState,
    required this.surnameValidationState,
    required this.phoneValidationState,
    required this.emailValidationState,
    required this.passwordValidationState,
    required this.repeatPasswordValidationState,
    this.selectedGender,
    this.selectedBirthDate,
  });

  factory CompleteEmailRegisterState.initial() => CompleteEmailRegisterState(
    obscurePassword: true,
    obscureRepeatPassword: true,
    registerState: StateStatus.initial(),
    nameValidationState: FieldValidationState.pure(),
    surnameValidationState: FieldValidationState.pure(),
    phoneValidationState: FieldValidationState.pure(),
    emailValidationState: FieldValidationState.pure(),
    passwordValidationState: FieldValidationState.pure(),
    repeatPasswordValidationState: FieldValidationState.pure(),
  );

  CompleteEmailRegisterState copyWith({
    bool? obscurePassword,
    bool? obscureRepeatPassword,
    StateStatus? registerState,
    FieldValidationState? nameValidationState,
    FieldValidationState? surnameValidationState,
    FieldValidationState? phoneValidationState,
    FieldValidationState? emailValidationState,
    FieldValidationState? passwordValidationState,
    FieldValidationState? repeatPasswordValidationState,
    Gender? selectedGender,
    DateTime? selectedBirthDate,
  }) {
    return CompleteEmailRegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureRepeatPassword: obscureRepeatPassword ?? this.obscureRepeatPassword,
      registerState: registerState ?? this.registerState,
      emailValidationState: emailValidationState ?? this.emailValidationState,
      nameValidationState: nameValidationState ?? this.nameValidationState,
      passwordValidationState: passwordValidationState ?? this.passwordValidationState,
      repeatPasswordValidationState: repeatPasswordValidationState ?? this.repeatPasswordValidationState,
      surnameValidationState: surnameValidationState ?? this.surnameValidationState,
      phoneValidationState: phoneValidationState ?? this.phoneValidationState,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedBirthDate: selectedBirthDate ?? this.selectedBirthDate,
    );
  }
}
