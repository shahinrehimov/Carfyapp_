part of 'complete_email_register_cubit.dart';

class CompleteEmailRegisterState {
  final bool obscurePassword;
  final bool obscureRepeatPassword;
  final StateStatus registerState;
  final FieldValidationState nameValidationState;
  final FieldValidationState surnameValidationState;
  final FieldValidationState emailValidationState;
  final Gender? selectedGender;
  final DateTime? selectedBirthDate;

  CompleteEmailRegisterState({
    required this.obscurePassword,
    required this.obscureRepeatPassword,
    required this.registerState,
    required this.nameValidationState,
    required this.surnameValidationState,
    required this.emailValidationState,
    this.selectedGender,
    this.selectedBirthDate,
  });

  factory CompleteEmailRegisterState.initial() => CompleteEmailRegisterState(
    obscurePassword: true,
    obscureRepeatPassword: true,
    registerState: StateStatus.initial(),
    nameValidationState: FieldValidationState.pure(),
    surnameValidationState: FieldValidationState.pure(),
    emailValidationState: FieldValidationState.pure(),
  );

  CompleteEmailRegisterState copyWith({
    bool? obscurePassword,
    bool? obscureRepeatPassword,
    StateStatus? registerState,
    FieldValidationState? nameValidationState,
    FieldValidationState? surnameValidationState,
    FieldValidationState? emailValidationState,
    Gender? selectedGender,
    DateTime? selectedBirthDate,
  }) {
    return CompleteEmailRegisterState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureRepeatPassword: obscureRepeatPassword ?? this.obscureRepeatPassword,
      registerState: registerState ?? this.registerState,
      emailValidationState: emailValidationState ?? this.emailValidationState,
      nameValidationState: nameValidationState ?? this.nameValidationState,
      surnameValidationState: surnameValidationState ?? this.surnameValidationState,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedBirthDate: selectedBirthDate ?? this.selectedBirthDate,
    );
  }
}
