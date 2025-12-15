import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/auth/login/state/verify_otp/verify_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../../../../common/translations/translation_context_extension.dart';
import '../../../../../gen/assets.gen.dart';

@RoutePage()
class LoginPhoneVerifyPage extends StatelessWidget implements AutoRouteWrapper {
  final String phone;

  const LoginPhoneVerifyPage({super.key, required this.phone});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => VerifyOtpCubit(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'OTP',
          style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        leading: InkWell(
          onTap: () => context.maybePop(),
          child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.arrowNarrowLeft, width: 24, height: 24)),
        ),
      ),
      backgroundColor: context.theme.colors.white,
      body: BlocListener<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          showStateStatusToast(context, state.verifyState);
        },
        listenWhen: (oldState, newState) => oldState.verifyState != newState.verifyState,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.localization.phoneVerification,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.primary),
            ),
            SizedBox(height: 8),
            Text(
              context.localization.phone,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: context.theme.colors.darkGray),
            ),
            SizedBox(height: 40),
            Pinput(
              length: 4,
              controller: context.read<VerifyOtpCubit>().otpController,
              defaultPinTheme: PinTheme(
                width: 70,
                height: 70,
                textStyle: TextStyle(fontSize: 20, color: context.theme.colors.black, fontWeight: FontWeight.w500),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: context.theme.colors.white,
                  border: Border.all(color: Color(0xFFA2ADC8)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onCompleted: (pin) => context.read<VerifyOtpCubit>().verifyWithOtp(phone, pin),
            ),
            SizedBox(height: 16),
            BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
              builder: (context, state) {
                return TimerWidget(
                  timeRemaining: state.timeRemaining,
                  isTimerActive: state.isTimerActive,
                  onResendTap: () => context.read<VerifyOtpCubit>().resendOtp(phone),
                );
              },
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => context.read<VerifyOtpCubit>().verify(phone),
                    loading: state.verifyState is StateStatusLoading,
                    text: context.localization.confirm,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int timeRemaining;
  final bool isTimerActive;
  final VoidCallback onResendTap;

  const TimerWidget({super.key, required this.timeRemaining, required this.isTimerActive, required this.onResendTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isTimerActive)
          Text(
            'Resend OTP in ${timeRemaining ~/ 60}:${(timeRemaining % 60).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 12, color: context.theme.colors.darkGray, fontWeight: FontWeight.w500),
          )
        else
          GestureDetector(
            onTap: onResendTap,
            child: Text(
              'Resend OTP',
              style: TextStyle(
                fontSize: 12,
                color: context.theme.colors.primary,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }
}
