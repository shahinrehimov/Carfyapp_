import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/forgot_password_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/error/failure.dart';
import '../../../../domain/use_cases/auth/forgot_password_use_case.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> with StateMapHelper {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AppRouter _appRouter;

  ForgotPasswordCubit({ForgotPasswordUseCase? forgotPasswordUseCase, AppRouter? appRouter})
    : _forgotPasswordUseCase = forgotPasswordUseCase ?? getIt<ForgotPasswordUseCase>(),
      _appRouter = appRouter ?? getIt<AppRouter>(),
      super(ForgotPasswordState.initial());

  final TextEditingController emailController = TextEditingController();

  Future<void> sendOtp() async {
    emit(state.copyWith(sendOtpState: StateStatus.loading()));

    emit(state.copyWith(emailValidationState: FieldValidationState.pure()));
    final email = emailController.text.trim();

    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    result.fold(
      (failure) {
        emit(state.copyWith(sendOtpState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(state.copyWith(emailValidationState: mapValidationFailure('email', failure)));
        }
      },
      (success) {
        emit(state.copyWith(sendOtpState: StateStatus.successWithMessage(success.message)));
      },
    );
  }
}
