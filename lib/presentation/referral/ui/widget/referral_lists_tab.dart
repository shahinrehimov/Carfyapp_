import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/enums/attribution_status.dart';
import 'package:carfy/domain/enums/earning_status.dart';
import 'package:carfy/domain/enums/withdrawal_status.dart';
import 'package:carfy/domain/entities/referral/referral_earning.dart';
import 'package:carfy/domain/entities/referral/referral_user.dart';
import 'package:carfy/domain/entities/referral/referral_withdrawal.dart';
import 'package:carfy/presentation/referral/state/referral_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferralListsTab extends StatefulWidget {
  const ReferralListsTab({super.key});

  @override
  State<ReferralListsTab> createState() => _ReferralListsTabState();
}

class _ReferralListsTabState extends State<ReferralListsTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _loadedTabs = <int>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTab(0);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final index = _tabController.index;
      context.read<ReferralCubit>().setTabIndex(index);
      _loadTab(index);
    }
  }

  void _loadTab(int index) {
    if (_loadedTabs.contains(index)) return;
    _loadedTabs.add(index);
    final cubit = context.read<ReferralCubit>();
    switch (index) {
      case 0:
        cubit.loadEarnings();
      case 1:
        cubit.loadReferrals();
      case 2:
        cubit.loadWithdrawals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            dividerColor: Colors.transparent,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.theme.colors.primary,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF717171),
            ),
            splashBorderRadius: BorderRadius.circular(10),
            tabs: [
              Tab(text: context.localization.referralEarnings, height: 36),
              Tab(text: context.localization.referralReferrals, height: 36),
              Tab(text: context.localization.referralWithdrawals, height: 36),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) => switch (_tabController.index) {
            0 => _EarningsTab(),
            1 => _ReferralsTab(),
            2 => _WithdrawalsTab(),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }
}

const _loader = Center(
  child: SizedBox(height: 200, child: CupertinoActivityIndicator()),
);
const _paginationLoader = Center(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: CupertinoActivityIndicator(),
  ),
);

bool _isLoadingOrInitial(StateStatus status) =>
    status is StateStatusLoading || status is StateStatusInitial;

// ── Earnings Tab ──

class _EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      buildWhen: (prev, curr) =>
          prev.earningsStatus != curr.earningsStatus ||
          prev.earnings != curr.earnings,
      builder: (context, state) {
        if (_isLoadingOrInitial(state.earningsStatus)) return _loader;
        if (state.earningsStatus is StateStatusEmpty) {
          return Center(
            child: Text(
              context.localization.referralEarningsEmpty,
              style: const TextStyle(fontSize: 14, color: Color(0xFF717171)),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              state.earnings.length +
              (state.earningsStatus is StateStatusPaginationLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == state.earnings.length) return _paginationLoader;
            return _EarningItem(earning: state.earnings[index]);
          },
        );
      },
    );
  }
}

class _EarningItem extends StatelessWidget {
  final ReferralEarning earning;

  const _EarningItem({required this.earning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${earning.orderAmount.toStringAsFixed(2)} ₼',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF242323),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${earning.rate} · ${earning.tier}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF717171),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${earning.amount.toStringAsFixed(2)} ₼',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 4),
              _EarningStatusBadge(status: earning.status),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Referrals Tab ──

class _ReferralsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      buildWhen: (prev, curr) =>
          prev.referralsStatus != curr.referralsStatus ||
          prev.referrals != curr.referrals,
      builder: (context, state) {
        if (_isLoadingOrInitial(state.referralsStatus)) return _loader;
        if (state.referralsStatus is StateStatusEmpty) {
          return Center(
            child: Text(
              context.localization.referralReferralsEmpty,
              style: const TextStyle(fontSize: 14, color: Color(0xFF717171)),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              state.referrals.length +
              (state.referralsStatus is StateStatusPaginationLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == state.referrals.length) return _paginationLoader;
            return _ReferralUserItem(user: state.referrals[index]);
          },
        );
      },
    );
  }
}

class _ReferralUserItem extends StatelessWidget {
  final ReferralUser user;

  const _ReferralUserItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF3696E7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: Color(0xFF3696E7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.referredName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF242323),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.joinedAt.substring(0, 10),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF717171),
                  ),
                ),
              ],
            ),
          ),
          _AttributionStatusBadge(status: user.status),
        ],
      ),
    );
  }
}

// ── Withdrawals Tab ──

class _WithdrawalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralCubit, ReferralState>(
      buildWhen: (prev, curr) =>
          prev.withdrawalsStatus != curr.withdrawalsStatus ||
          prev.withdrawals != curr.withdrawals,
      builder: (context, state) {
        if (_isLoadingOrInitial(state.withdrawalsStatus)) return _loader;
        if (state.withdrawalsStatus is StateStatusEmpty) {
          return Center(
            child: Text(
              context.localization.referralWithdrawalsEmpty,
              style: const TextStyle(fontSize: 14, color: Color(0xFF717171)),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              state.withdrawals.length +
              (state.withdrawalsStatus is StateStatusPaginationLoading ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == state.withdrawals.length) return _paginationLoader;
            return _WithdrawalItem(withdrawal: state.withdrawals[index]);
          },
        );
      },
    );
  }
}

class _WithdrawalItem extends StatelessWidget {
  final ReferralWithdrawal withdrawal;

  const _WithdrawalItem({required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '**** ${withdrawal.cardLast4}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF242323),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  withdrawal.requestedAt.substring(0, 10),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF717171),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${withdrawal.amount.toStringAsFixed(2)} ₼',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF6683C),
                ),
              ),
              const SizedBox(height: 4),
              _WithdrawalStatusBadge(status: withdrawal.status),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Earning Status Badge ──

class _EarningStatusBadge extends StatelessWidget {
  final EarningStatus status;

  const _EarningStatusBadge({required this.status});

  Color get _color => switch (status) {
    EarningStatus.available => const Color(0xFF4CAF50),
    EarningStatus.pending => const Color(0xFFF6A623),
    EarningStatus.refunded ||
    EarningStatus.cancelled => const Color(0xFFF44336),
    EarningStatus.fraudHold => const Color(0xFFFF9800),
  };

  String _label(BuildContext context) => switch (status) {
    EarningStatus.pending => context.localization.earningStatusPending,
    EarningStatus.available => context.localization.earningStatusAvailable,
    EarningStatus.refunded => context.localization.earningStatusRefunded,
    EarningStatus.cancelled => context.localization.earningStatusCancelled,
    EarningStatus.fraudHold => context.localization.earningStatusFraudHold,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label(context),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _color,
        ),
      ),
    );
  }
}

// ── Attribution Status Badge ──

class _AttributionStatusBadge extends StatelessWidget {
  final AttributionStatus status;

  const _AttributionStatusBadge({required this.status});

  Color get _color => switch (status) {
    AttributionStatus.active => const Color(0xFF4CAF50),
    AttributionStatus.pending => const Color(0xFFF6A623),
    AttributionStatus.fraudBlocked => const Color(0xFFF44336),
  };

  String _label(BuildContext context) => switch (status) {
    AttributionStatus.pending => context.localization.attributionStatusPending,
    AttributionStatus.active => context.localization.attributionStatusActive,
    AttributionStatus.fraudBlocked =>
      context.localization.attributionStatusFraudBlocked,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label(context),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _color,
        ),
      ),
    );
  }
}

// ── Withdrawal Status Badge ──

class _WithdrawalStatusBadge extends StatelessWidget {
  final WithdrawalStatus status;

  const _WithdrawalStatusBadge({required this.status});

  Color get _color => switch (status) {
    WithdrawalStatus.paid => const Color(0xFF4CAF50),
    WithdrawalStatus.approved => const Color(0xFF3696E7),
    WithdrawalStatus.pending => const Color(0xFFF6A623),
    WithdrawalStatus.rejected => const Color(0xFFF44336),
  };

  String _label(BuildContext context) => switch (status) {
    WithdrawalStatus.pending => context.localization.withdrawalStatusPending,
    WithdrawalStatus.approved => context.localization.withdrawalStatusApproved,
    WithdrawalStatus.paid => context.localization.withdrawalStatusPaid,
    WithdrawalStatus.rejected => context.localization.withdrawalStatusRejected,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label(context),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _color,
        ),
      ),
    );
  }
}
