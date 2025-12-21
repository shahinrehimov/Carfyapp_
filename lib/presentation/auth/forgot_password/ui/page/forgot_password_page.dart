import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/presentation/auth/forgot_password/state/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/gen/assets.gen.dart';

@RoutePage()
class ForgotPasswordPage extends StatelessWidget implements AutoRouteWrapper {
  const ForgotPasswordPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => ForgotPasswordCubit(), child: this);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.maybePop(),
          child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.arrowNarrowLeft, width: 24, height: 24)),
        ),
      ),
      backgroundColor: context.theme.colors.white,
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          showStateStatusToast(context, state.sendOtpState);
        },
        listenWhen: (oldState, newState) => oldState.sendOtpState != newState.sendOtpState,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.localization.passwordRecovery,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.primary),
              ),
              const SizedBox(height: 28),
              BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                builder: (context, state) {
                  return CustomTextField(
                    controller: cubit.emailController,
                    hint: context.localization.email,
                    errorText: state.emailValidationState.message,
                    inputFormatters: [InputFormatter.getEmailFormatter()],
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                builder: (context, state) {
                  return CustomButton(
                    onPressed: () => cubit.sendOtp(),
                    loading: state.sendOtpState is StateStatusLoading,
                    text: context.localization.continueBtn,
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
