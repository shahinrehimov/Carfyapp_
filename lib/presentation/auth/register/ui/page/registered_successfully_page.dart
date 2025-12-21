import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/gen/assets.gen.dart';

@RoutePage()
class RegisteredSuccessfullyPage extends StatelessWidget {
  const RegisteredSuccessfullyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.maxFinite),
          Image.asset(Assets.images.successfullyRegistered.path, height: 139),
          Text(
            context.localization.successfullyRegistered,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: context.theme.colors.textDark),
          ),
          const SizedBox(height: 24),
          CustomButton(
            onPressed: () => context.router.replaceAll([const LoginRoute()]),
            width: 268,
            text: context.localization.login,
          ),
        ],
      ),
    );
  }
}
