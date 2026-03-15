import 'package:auto_route/annotations.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBar(
        title: context.localization.mainMessage,
        actions: [IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.notification))],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.images.messageNotLogged.path, height: 168),
            const SizedBox(height: 16),
            Text(
              context.localization.messagesEmpty,
              style: TextStyle(fontSize: 18, color: context.theme.colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
