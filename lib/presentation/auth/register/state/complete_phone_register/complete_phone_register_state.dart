part of 'complete_phone_register_cubit.dart';

class CompletePhoneRegisterState {
  final bool obscurePassword;
  final bool obscureRepeatPassword;
  final StateStatus registerState;
  final FieldValidationState nameValidationState;
  final FieldValidationState surnameValidationState;
  final FieldValidationState emailValidationState;
  final Gender? selectedGender;
  final DateTime? selectedBirthDate;

  CompletePhoneRegisterState({
    required this.obscurePassword,
    required this.obscureRepeatPassword,
    required this.registerState,
    required this.nameValidationState,
    required this.surnameValidationState,
    required this.emailValidationState,
    this.selectedGender,
    this.selectedBirthDate,
  });

  factory CompletePhoneRegisterState.initial() => CompletePhoneRegisterState(
    obscurePassword: true,
    obscureRepeatPassword: true,
    registerState: StateStatus.initial(),
    nameValidationState: FieldValidationState.pure(),
    surnameValidationState: FieldValidationState.pure(),
    emailValidationState: FieldValidationState.pure(),
  );

  CompletePhoneRegisterState copyWith({
    bool? obscurePassword,
    bool? obscureRepeatPassword,
    StateStatus? registerState,
    FieldValidationState? nameValidationState,
    FieldValidationState? surnameValidationState,
    FieldValidationState? emailValidationState,
    Gender? selectedGender,
    DateTime? selectedBirthDate,
  }) {
    return CompletePhoneRegisterState(
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
