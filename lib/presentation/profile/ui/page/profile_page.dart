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
import 'package:carfy/common/widgets/custom_app_bar.dart';

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
            height: 100,
            actions: [IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icons.notification))],
            flexibleSpace: const SafeArea(child: _ProfileFlexibleSpace()),
          ),
          body: const Center(child: Text('profile')),
        );
      },
    );
  }
}

class _ProfileFlexibleSpace extends StatelessWidget {
  const _ProfileFlexibleSpace();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.status.maybeWhen(
          success: () => _ProfileName(name: state.user?.fullName ?? ''),
          orElse: () => const _ProfileNameShimmer(),
        );
      },
    );
  }
}

class _ProfileName extends StatelessWidget {
  final String name;

  const _ProfileName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(color: context.theme.colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SvgPicture.asset(
            Assets.icons.chevronRight,
            height: 26,
            colorFilter: ColorFilter.mode(context.theme.colors.white, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}

class _ProfileNameShimmer extends StatelessWidget {
  const _ProfileNameShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(bottom: 16, left: 16),
      child: ShimmerWrapper(
        child: Container(
          width: 120,
          height: 22,
          decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }
}
