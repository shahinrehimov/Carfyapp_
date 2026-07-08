import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/state/field_validation_state.dart';
import 'package:carfy/common/util/input_formatters.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/custom_button.dart';
import 'package:carfy/common/widgets/custom_phone_field.dart';
import 'package:carfy/common/widgets/custom_text_field.dart';
import 'package:carfy/common/widgets/tab_bar.dart';
import 'package:carfy/presentation/auth/register/state/register_cubit.dart';
import 'package:carfy/presentation/auth/ui/widget/social_login_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/widgets/state_status_toast.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';

part '../widget/common.dart';

part '../widget/with_email.dart';

part '../widget/with_number.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: Scaffold(
        appBar: const CustomAppBar().copyWith(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: CustomTabBar(
              titles: [context.localization.withNumber, context.localization.withEmail],
              children: [const _RegisterWithNumber(), const _RegisterWithEmail()],
            ),
          ),
        ),
      ),
    );
  }
}
