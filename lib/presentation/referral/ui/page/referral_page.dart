import 'package:auto_route/auto_route.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/widgets/custom_app_bar.dart';
import 'package:carfy/common/widgets/pagination_scroll_wrapper.dart';
import 'package:carfy/presentation/referral/state/referral_cubit.dart';
import 'package:carfy/presentation/referral/ui/widget/balance_details.dart';
import 'package:carfy/presentation/referral/ui/widget/bonus.dart';
import 'package:carfy/presentation/referral/ui/widget/referral_info_card.dart';
import 'package:carfy/presentation/referral/ui/widget/referral_lists_tab.dart';
import 'package:carfy/presentation/referral/ui/widget/referral_perks_card.dart';
import 'package:carfy/presentation/referral/ui/widget/update_code_bottom_sheet.dart';
import 'package:carfy/presentation/referral/ui/widget/withdrawal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ReferralPage extends StatelessWidget implements AutoRouteWrapper {
  const ReferralPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => ReferralCubit()..load(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colors.bg,
      appBar: CustomAppBarWhite(title: context.localization.profileReferrals),
      body: PaginationScrollWrapper(
        onLoadMore: () => context.read<ReferralCubit>().loadMoreCurrentTab(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            BlocBuilder<ReferralCubit, ReferralState>(
              buildWhen: (prev, curr) =>
                  prev.status != curr.status || prev.info != curr.info || prev.perks != curr.perks,
              builder: (context, state) {
                final isLoading = state.status is StateStatusLoading;
                return Column(
                  children: [
                    Bonus(bonus: state.info?.availableBalance ?? 0, loading: isLoading),
                    const SizedBox(height: 16),
                    BalanceDetails(
                      info: state.info,
                      loading: isLoading,
                      onWithdraw: () => showWithdrawalBottomSheet(context),
                    ),
                    const SizedBox(height: 16),
                    ReferralInfoCard(
                      info: state.info,
                      loading: isLoading,
                      onEditCode: () => showUpdateCodeBottomSheet(context),
                    ),
                    if (state.perks != null && state.perks!.hasPerks) ...[
                      const SizedBox(height: 16),
                      ReferralPerksCard(perks: state.perks!),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const ReferralListsTab(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
