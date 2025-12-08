import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/theme/theme.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../localization/languages/languages.dart';

@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => context.pop(),
          child: UnconstrainedBox(child: SvgPicture.asset(Assets.icons.arrowNarrowLeft, width: 24, height: 24)),
        ),
      ),
      backgroundColor: context.theme.colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Languages.of(context)!.passwordRecovery,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.theme.colors.primary),
            ),
            SizedBox(height: 28),
            CustomTextField(
              controller: TextEditingController(),
              hint: Languages.of(context)!.email,
              inputFormatters: [InputFormatter.getEmailFormatter()],
            ),
            SizedBox(height: 16),
            CustomButton(onPressed: () {}, text: Languages.of(context)!.$continue),
          ],
        ),
      ),
    );
  }
}
