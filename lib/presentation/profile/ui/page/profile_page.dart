import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/widgets/not_logged_view.dart';
import 'package:carfy/common/widgets/shimmer_wrapper.dart';
import 'package:carfy/gen/assets.gen.dart';
import 'package:carfy/presentation/profile/state/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/router/app_router.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';

part '../widget/profile_flexible_space.dart';
part '../widget/profile_body.dart';
part '../widget/profile_menu_card.dart';
part '../widget/profile_section_card.dart';

@RoutePage()
class ProfilePage extends StatelessWidget implements AutoRouteWrapper {
  const ProfilePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => ProfileCubit()..init(), child: this);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (!state.authenticated) {
          return Scaffold(
            backgroundColor: context.theme.colors.bg,
            body: const Center(child: NotLoggedView(page: NotLoggedPage.profile)),
          );
        }
        return Scaffold(
          backgroundColor: context.theme.colors.bg,
          appBar: CustomAppBar(
            title: context.localization.mainProfile,
            height: 140,
            actions: [IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.notification))],
            flexibleSpace: const SafeArea(child: _ProfileFlexibleSpace()),
          ),
          body: const _ProfileBody(),
        );
      },
    );
  }
}
