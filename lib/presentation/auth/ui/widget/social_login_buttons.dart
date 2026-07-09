import 'dart:io';

import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/auth/state/social_login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SocialLoginCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SocialLoginCubit, SocialLoginState>(
            listenWhen: (prev, curr) => prev.googleStatus != curr.googleStatus,
            listener: (context, state) => showStateStatusToast(context, state.googleStatus),
          ),
          BlocListener<SocialLoginCubit, SocialLoginState>(
            listenWhen: (prev, curr) => prev.appleStatus != curr.appleStatus,
            listener: (context, state) => showStateStatusToast(context, state.appleStatus),
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<SocialLoginCubit, SocialLoginState>(
              buildWhen: (prev, curr) => prev.googleStatus != curr.googleStatus,
              builder: (context, state) => CustomButton(
                onPressed: state.googleStatus is StateStatusLoading
                    ? null
                    : () => context.read<SocialLoginCubit>().loginWithGoogle(),
                text: context.localization.google,
                backgroundColor: Colors.transparent,
                outlineColor: context.theme.colors.secondary,
                color: const Color(0xFF0E1217),
                fontWeight: FontWeight.w700,
                fontSize: 18,
                prefix: SvgPicture.asset(Assets.icons.googleIconLogo),
              ),
            ),
            if (Platform.isIOS) ...[
              const SizedBox(height: 16),
              BlocBuilder<SocialLoginCubit, SocialLoginState>(
                buildWhen: (prev, curr) => prev.appleStatus != curr.appleStatus,
                builder: (context, state) => CustomButton(
                  onPressed: state.appleStatus is StateStatusLoading
                      ? null
                      : () => context.read<SocialLoginCubit>().loginWithApple(),
                  text: context.localization.apple,
                  backgroundColor: Colors.transparent,
                  outlineColor: context.theme.colors.secondary,
                  color: const Color(0xFF0E1217),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  prefix: SvgPicture.asset(Assets.icons.appleIconLogo),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
