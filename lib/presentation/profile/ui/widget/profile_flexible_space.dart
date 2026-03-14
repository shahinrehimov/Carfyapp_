part of '../page/profile_page.dart';

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
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colors.white.withValues(alpha: 0.3),
            ),
            child: Center(
              child: SvgPicture.asset(Assets.icons.profile, width: 32, height: 32,
                colorFilter: ColorFilter.mode(context.theme.colors.white, BlendMode.srcIn)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(color: context.theme.colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
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
      child: Row(
        children: [
          ShimmerWrapper(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ShimmerWrapper(
            child: Container(
              width: 120,
              height: 22,
              decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}
