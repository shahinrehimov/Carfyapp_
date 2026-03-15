import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/util/device_util.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/enums/gender.dart';
import 'package:carfy/domain/params/auth/register_with_phone_params.dart';
import 'package:carfy/domain/use_cases/auth/register_with_phone_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/error/failure.dart';

part 'complete_phone_register_state.dart';

class CompletePhoneRegisterCubit extends Cubit<CompletePhoneRegisterState> with StateMapHelper {
  final RegisterWithPhoneUseCase _registerWithPhoneUseCase;
  final AppRouter _appRouter;

  CompletePhoneRegisterCubit({RegisterWithPhoneUseCase? registerWithPhoneUseCase, AppRouter? appRouter})
    : _registerWithPhoneUseCase = registerWithPhoneUseCase ?? getIt<RegisterWithPhoneUseCase>(),
      _appRouter = appRouter ?? getIt<AppRouter>(),
      super(CompletePhoneRegisterState.initial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void selectGender(Gender gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void selectBirthDate(DateTime date) {
    emit(state.copyWith(selectedBirthDate: date));
  }

  void register({required String phone, required String phoneConfirmationToken, required int otp}) async {
    final name = nameController.text;
    final surname = surnameController.text;
    final email = emailController.text;
    final deviceName = await DeviceUtil.getDeviceName();

    final params = RegisterWithPhoneParams(
      name: name,
      surname: surname,
      gender: state.selectedGender,
      birthDate: state.selectedBirthDate,
      email: email,
      phone: phone,
      phoneConfirmationToken: phoneConfirmationToken,
      otp: otp,
      deviceName: deviceName,
    );

    emit(state.copyWith(registerState: StateStatus.loading()));

    final result = await _registerWithPhoneUseCase(params);
    result.fold(
      (failure) {
        emit(state.copyWith(registerState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(state.copyWith(nameValidationState: mapValidationFailure('name', failure)));
          emit(state.copyWith(surnameValidationState: mapValidationFailure('surname', failure)));
          emit(state.copyWith(emailValidationState: mapValidationFailure('email', failure)));
        }
      },
      (success) {
        emit(state.copyWith(registerState: StateStatus.success()));
        _appRouter.replaceAll([const RegisteredSuccessfullyRoute()]);
      },
    );
  }
}
