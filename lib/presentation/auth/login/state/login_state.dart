part of 'login_cubit.dart';

class LoginState {
  final bool obscurePassword;
  final StateStatus emailLoginState;
  final FieldValidationState emailValidationState;
  final FieldValidationState passwordValidationState;
  final StateStatus phoneLoginState;
  final FieldValidationState phoneValidationState;

  LoginState({
    required this.obscurePassword,
    required this.emailLoginState,
    required this.emailValidationState,
    required this.passwordValidationState,
    required this.phoneLoginState,
    required this.phoneValidationState,
  });

  factory LoginState.initial() => LoginState(
    obscurePassword: true,
    emailLoginState: StateStatus.initial(),
    emailValidationState: FieldValidationState.pure(),
    passwordValidationState: FieldValidationState.pure(),
    phoneLoginState: StateStatus.initial(),
    phoneValidationState: FieldValidationState.pure(),
  );

  LoginState copyWith({
    bool? obscurePassword,
    StateStatus? emailLoginState,
    FieldValidationState? emailValidationState,
    FieldValidationState? passwordValidationState,
    StateStatus? phoneLoginState,
    FieldValidationState? phoneValidationState,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      emailLoginState: emailLoginState ?? this.emailLoginState,
      emailValidationState: emailValidationState ?? this.emailValidationState,
      passwordValidationState: passwordValidationState ?? this.passwordValidationState,
      phoneLoginState: phoneLoginState ?? this.phoneLoginState,
      phoneValidationState: phoneValidationState ?? this.phoneValidationState,
    );
  }
}
