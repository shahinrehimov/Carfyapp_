import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

import '../../../../../common/state/state_status.dart';
import '../../../../../common/theme/theme.dart';
import '../../../../../common/translations/translation_context_extension.dart';
import '../../../../../common/translations/translation_keys.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/state_status_toast.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../login/ui/page/login_phone_verify_page.dart';
import '../../state/phone_verify_otp/phone_verify_otp_cubit.dart';

@RoutePage()
class RegisterPhoneOtpVerifyPage extends StatelessWidget implements AutoRouteWrapper {
  final String phone;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => PhoneVerifyOtpCubit(), child: this);

  const RegisterPhoneOtpVerifyPage({super.key, required this.phone});

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
      body: BlocListener<PhoneVerifyOtpCubit, PhoneVerifyOtpState>(
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
              context.localization.otpSentToNumber(phone),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: context.theme.colors.darkGray),
            ),
            SizedBox(height: 40),
            Pinput(
              length: 4,
              controller: context.read<PhoneVerifyOtpCubit>().otpController,
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
              onCompleted: (pin) => context.read<PhoneVerifyOtpCubit>().verifyWithOtp(phone, pin),
            ),
            SizedBox(height: 16),
            BlocBuilder<PhoneVerifyOtpCubit, PhoneVerifyOtpState>(
              builder: (context, state) {
                return TimerWidget(
                  timeRemaining: state.timeRemaining,
                  isTimerActive: state.isTimerActive,
                  onResendTap: () => context.read<PhoneVerifyOtpCubit>().resendOtp(phone),
                );
              },
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: BlocBuilder<PhoneVerifyOtpCubit, PhoneVerifyOtpState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => context.read<PhoneVerifyOtpCubit>().verify(phone),
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
