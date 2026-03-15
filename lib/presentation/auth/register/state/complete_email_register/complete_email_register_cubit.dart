import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/util/device_util.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/enums/gender.dart';
import 'package:carfy/domain/use_cases/auth/register_with_email_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/params/auth/register_with_email_params.dart';

part 'complete_email_register_state.dart';

class CompleteEmailRegisterCubit extends Cubit<CompleteEmailRegisterState> with StateMapHelper {
  final RegisterWithEmailUseCase _registerWithEmailUseCase;
  final AppRouter _appRouter;

  CompleteEmailRegisterCubit({RegisterWithEmailUseCase? registerWithEmailUseCase, AppRouter? appRouter})
    : _registerWithEmailUseCase = registerWithEmailUseCase ?? getIt<RegisterWithEmailUseCase>(),
      _appRouter = appRouter ?? getIt<AppRouter>(),
      super(CompleteEmailRegisterState.initial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void init(String email) {
    emailController.text = email;
  }

  void selectGender(Gender gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void selectBirthDate(DateTime date) {
    emit(state.copyWith(selectedBirthDate: date));
  }

  void register() async {
    final name = nameController.text;
    final surname = surnameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final repeatPassword = repeatPasswordController.text;
    final phone = phoneController.text.replaceAll(' ', '');
    final deviceName = await DeviceUtil.getDeviceName();

    final params = RegisterWithEmailParams(
      name: name,
      surname: surname,
      gender: state.selectedGender?.name,
      birthDate: state.selectedBirthDate != null ? DateFormat('dd.MM.yyyy').format(state.selectedBirthDate!) : null,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: repeatPassword,
      deviceName: deviceName,
    );

    emit(state.copyWith(registerState: StateStatus.loading()));

    final result = await _registerWithEmailUseCase(params);
    result.fold(
      (failure) {
        emit(state.copyWith(registerState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(state.copyWith(nameValidationState: mapValidationFailure('name', failure)));
          emit(state.copyWith(surnameValidationState: mapValidationFailure('surname', failure)));
          emit(state.copyWith(emailValidationState: mapValidationFailure('email', failure)));
          emit(state.copyWith(phoneValidationState: mapValidationFailure('phone', failure)));
          emit(state.copyWith(passwordValidationState: mapValidationFailure('password', failure)));
        }
      },
      (success) {
        emit(state.copyWith(registerState: StateStatus.success()));
        _appRouter.push(VerifyEmailRoute(email: email, userUuid: success.user.uuid));
      },
    );
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleObscureRepeatPassword() {
    emit(state.copyWith(obscureRepeatPassword: !state.obscureRepeatPassword));
  }

  void clearValidations() {
    emit(
      state.copyWith(
        nameValidationState: FieldValidationState.pure(),
        surnameValidationState: FieldValidationState.pure(),
        emailValidationState: FieldValidationState.pure(),
        phoneValidationState: FieldValidationState.pure(),
        passwordValidationState: FieldValidationState.pure(),
        repeatPasswordValidationState: FieldValidationState.pure(),
      ),
    );
  }
}
