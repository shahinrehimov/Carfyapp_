import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/auth/register/state/email_verify_otp/email_verify_otp_cubit.dart';

@RoutePage()
class VerifyEmailPage extends StatelessWidget implements AutoRouteWrapper {
  final String email;
  final String userUuid;

  const VerifyEmailPage({super.key, required this.email, required this.userUuid});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => EmailVerifyOtpCubit(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.localization.emailVerification,
          style: TextStyle(color: context.theme.colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: context.theme.colors.white,
      body: BlocListener<EmailVerifyOtpCubit, EmailVerifyOtpState>(
        listener: (context, state) {
          showStateStatusToast(context, state.verifyState);
        },
        listenWhen: (oldState, newState) => oldState.verifyState != newState.verifyState,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.localization.emailVerification,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.primary),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.localization.otpSentToEmail(email),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: context.theme.colors.darkGray),
              ),
            ),
            const SizedBox(height: 40),
            Pinput(
              length: 4,
              controller: context.read<EmailVerifyOtpCubit>().otpController,
              defaultPinTheme: PinTheme(
                width: 70,
                height: 70,
                textStyle: TextStyle(fontSize: 20, color: context.theme.colors.black, fontWeight: FontWeight.w500),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: context.theme.colors.white,
                  border: Border.all(color: const Color(0xFFA2ADC8)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onCompleted: (pin) => context.read<EmailVerifyOtpCubit>().verifyWithOtp(email, pin, userUuid),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: BlocBuilder<EmailVerifyOtpCubit, EmailVerifyOtpState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => context.read<EmailVerifyOtpCubit>().verify(email, userUuid),
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
