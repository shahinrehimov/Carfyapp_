import 'dart:async';

import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/util/device_util.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/params/auth/login_with_email_params.dart';
import 'package:carfy/domain/params/auth/login_with_phone_otp_params.dart';
import 'package:carfy/domain/use_cases/auth/login_with_email_use_case.dart';
import 'package:carfy/domain/use_cases/auth/send_phone_login_otp_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/error/failure.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> with StateMapHelper {
  final LoginWithEmailUseCase _loginWithEmailUseCase;
  final SendPhoneLoginOtpUseCase _sendPhoneLoginOtpUseCase;
  final AppRouter _appRouter;

  LoginCubit({
    LoginWithEmailUseCase? loginWithEmailUseCase,
    SendPhoneLoginOtpUseCase? sendPhoneLoginOtpUseCase,
    AppRouter? appRouter,
  }) : _loginWithEmailUseCase = loginWithEmailUseCase ?? getIt<LoginWithEmailUseCase>(),
       _sendPhoneLoginOtpUseCase = sendPhoneLoginOtpUseCase ?? getIt<SendPhoneLoginOtpUseCase>(),
       _appRouter = appRouter ?? getIt<AppRouter>(),
       super(LoginState.initial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Timer? _emailRateLimitTimer;
  Timer? _phoneRateLimitTimer;

  void toggleObscureText() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> loginWithEmail() async {
    emit(state.copyWith(emailLoginState: StateStatus.loading()));

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    emit(
      state.copyWith(
        emailValidationState: FieldValidationState.pure(),
        passwordValidationState: FieldValidationState.pure(),
      ),
    );

    final deviceName = await DeviceUtil.getDeviceName();
    final result = await _loginWithEmailUseCase(
      LoginWithEmailParams(email: email, password: password, deviceName: deviceName),
    );
    result.fold(
      (failure) {
        final status = mapFailure(failure);
        emit(state.copyWith(emailLoginState: status));
        if (status is StateStatusBlockedFailure) {
          _startEmailCountdown(status.seconds);
        }
        if (failure is ValidationFailure) {
          emit(
            state.copyWith(
              emailValidationState: mapValidationFailure('email', failure),
              passwordValidationState: mapValidationFailure('password', failure),
            ),
          );
        }
      },
      (_) {
        emit(state.copyWith(emailLoginState: StateStatus.success()));
        _appRouter.pushAndPopUntil(const MainRoute(), predicate: (_) => false);
      },
    );
  }

  Future<void> loginWithNumber() async {
    emit(state.copyWith(phoneLoginState: StateStatus.loading()));

    emit(state.copyWith(phoneValidationState: FieldValidationState.pure()));
    final phone = phoneController.text.trim().replaceAll(' ', '');

    final result = await _sendPhoneLoginOtpUseCase(LoginWithPhoneOtpParams(phone: phone));
    result.fold(
      (failure) {
        final status = mapFailure(failure);
        emit(state.copyWith(phoneLoginState: status));
        if (status is StateStatusBlockedFailure) {
          _startPhoneCountdown(status.seconds);
        }
        if (failure is ValidationFailure) {
          emit(state.copyWith(phoneValidationState: mapValidationFailure('phone', failure)));
        }
      },
      (success) {
        emit(state.copyWith(phoneLoginState: StateStatus.success()));
        _appRouter.push(LoginPhoneVerifyRoute(phone: phone));
      },
    );
  }

  void _startEmailCountdown(int seconds) {
    _emailRateLimitTimer?.cancel();
    _emailRateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) { timer.cancel(); return; }
      final current = state.emailLoginState;
      if (current is! StateStatusBlockedFailure) { timer.cancel(); return; }
      final remaining = current.seconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(emailLoginState: StateStatus.initial()));
      } else {
        emit(state.copyWith(emailLoginState: StateStatus.blockedFailure(remaining)));
      }
    });
  }

  void _startPhoneCountdown(int seconds) {
    _phoneRateLimitTimer?.cancel();
    _phoneRateLimitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) { timer.cancel(); return; }
      final current = state.phoneLoginState;
      if (current is! StateStatusBlockedFailure) { timer.cancel(); return; }
      final remaining = current.seconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(phoneLoginState: StateStatus.initial()));
      } else {
        emit(state.copyWith(phoneLoginState: StateStatus.blockedFailure(remaining)));
      }
    });
  }

  @override
  Future<void> close() {
    _emailRateLimitTimer?.cancel();
    _phoneRateLimitTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
