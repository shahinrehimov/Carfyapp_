import 'dart:async';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/forgot_password_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/use_cases/auth/forgot_password_use_case.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> with StateMapHelper {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit({ForgotPasswordUseCase? forgotPasswordUseCase})
    : _forgotPasswordUseCase = forgotPasswordUseCase ?? getIt<ForgotPasswordUseCase>(),

      super(ForgotPasswordState.initial());

  final TextEditingController emailController = TextEditingController();
  Timer? _rateLimitTimer;

  Future<void> sendOtp() async {
    emit(state.copyWith(sendOtpState: StateStatus.loading()));

    emit(state.copyWith(emailValidationState: FieldValidationState.pure()));
    final email = emailController.text.trim();

    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    result.fold(
      (failure) {
        final status = mapFailure(failure);
        emit(state.copyWith(sendOtpState: status));
        if (status is StateStatusBlockedFailure) {
          _startCountdown(status.seconds);
        }
        if (failure is ValidationFailure) {
          emit(state.copyWith(emailValidationState: mapValidationFailure('email', failure)));
        }
      },
      (success) {
        emit(state.copyWith(sendOtpState: StateStatus.successWithMessage(success.message)));
      },
    );
  }

  void _startCountdown(int seconds) {
    _rateLimitTimer?.cancel();
    _rateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) { timer.cancel(); return; }
      final current = state.sendOtpState;
      if (current is! StateStatusBlockedFailure) { timer.cancel(); return; }
      final remaining = current.seconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(sendOtpState: StateStatus.initial()));
      } else {
        emit(state.copyWith(sendOtpState: StateStatus.blockedFailure(remaining)));
      }
    });
  }

  @override
  Future<void> close() {
    _rateLimitTimer?.cancel();
    emailController.dispose();
    return super.close();
  }
}
