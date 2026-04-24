import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/util/device_util.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/util/pref_util.dart';
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
    final result = await _loginWithEmailUseCase(LoginWithEmailParams(email: email, password: password, deviceName: deviceName));
    result.fold(
      (failure) {
        emit(state.copyWith(emailLoginState: mapFailure(failure)));
        if (failure is ValidationFailure) {
          emit(
            state.copyWith(
              emailValidationState: mapValidationFailure('email', failure),
              passwordValidationState: mapValidationFailure('password', failure),
            ),
          );
        }
      },
      (success) {
        emit(state.copyWith(emailLoginState: StateStatus.success()));
        PrefUtil.setString(AppPreferenceKeys.authToken, success.token);
        PrefUtil.remove(AppPreferenceKeys.guestIdentifier);
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
        emit(state.copyWith(phoneLoginState: mapFailure(failure)));
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
}
