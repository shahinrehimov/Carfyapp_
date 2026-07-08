import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/constants/constants.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.theme.colors.bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.images.splashLogo.path, height: 120),
                const SizedBox(height: 32),
                Text(
                  context.localization.forceUpdateTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: context.theme.colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  context.localization.forceUpdateMessage,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.theme.colors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  onPressed: () async {
                    final url = Platform.isIOS ? Constants.iosStoreUrl : Constants.androidStoreUrl;
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  text: context.localization.forceUpdateButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
