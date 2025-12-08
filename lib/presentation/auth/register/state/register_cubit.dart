import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/check_email_params.dart';
import 'package:carfy/domain/use_cases/auth/check_email_use_case.dart';
import 'package:carfy/domain/use_cases/auth/send_phone_otp_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/error/failure.dart';
import '../../../../domain/params/auth/send_phone_otp_params.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> with StateMapHelper {
  final CheckEmailUseCase _checkEmailUseCase;
  final SendPhoneRegisterOtpUseCase _sendPhoneRegisterOtpUseCase;
  final AppRouter _appRouter;

  RegisterCubit({
    CheckEmailUseCase? checkEmailUseCase,
    SendPhoneRegisterOtpUseCase? sendPhoneRegisterOtpUseCase,
    AppRouter? appRouter,
  }) : _checkEmailUseCase = checkEmailUseCase ?? getIt<CheckEmailUseCase>(),
       _sendPhoneRegisterOtpUseCase = sendPhoneRegisterOtpUseCase ?? getIt<SendPhoneRegisterOtpUseCase>(),
       _appRouter = appRouter ?? getIt<AppRouter>(),
       super(RegisterState.initial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> checkEmail() async {
    emit(state.copyWith(checkEmailState: StateStatus.loading()));

    final email = emailController.text.trim();
    emit(state.copyWith(emailValidationState: FieldValidationState.pure()));

    final result = await _checkEmailUseCase(CheckEmailParams(email: email));

    result.fold(
      (failure) {
        emit(state.copyWith(checkEmailState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(state.copyWith(emailValidationState: mapValidationFailure('email', failure)));
        }
      },
      (success) {
        emit(state.copyWith(checkEmailState: StateStatus.success()));
        _appRouter.push(CompleteEmailRegisterRoute(email: email));
      },
    );
  }

  Future<void> registerWithNumber() async {
    emit(state.copyWith(phoneRegisterState: StateStatus.loading()));

    emit(state.copyWith(phoneValidationState: FieldValidationState.pure()));
    final phone = phoneController.text.trim().replaceAll(' ', '');

    final result = await _sendPhoneRegisterOtpUseCase(SendPhoneOtpParams(phone: phone));
    result.fold(
      (failure) {
        emit(state.copyWith(phoneRegisterState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(state.copyWith(phoneValidationState: mapValidationFailure('phone', failure)));
        }
      },
      (success) {
        emit(state.copyWith(phoneRegisterState: StateStatus.success()));
        _appRouter.push(RegisterPhoneOtpVerifyRoute(phone: phone));
      },
    );
  }
}
