import 'package:auto_route/annotations.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/tab_bar.dart';
import 'package:carfy/localization/languages/languages.dart';
import 'package:carfy/presentation/auth/login/state/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/state/state_status.dart';
import '../../../../../common/theme/theme.dart';
import '../../../../../common/widgets/state_status_toast.dart';
import '../../../../../gen/assets.gen.dart';

part '../widget/common.dart';

part '../widget/with_email.dart';

part '../widget/with_number.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: CustomAppBar().copyWith(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: CustomTabBar(
              titles: [Languages.of(context)!.withNumber, Languages.of(context)!.withEmail],
              children: [_LoginWithNumber(), _LoginWithEmail()],
            ),
          ),
        ),
      ),
    );
  }
}
