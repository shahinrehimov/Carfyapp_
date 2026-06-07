import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:flutter/material.dart';

class BalanceDetails extends StatelessWidget {
  final ReferralInfo? info;
  final bool loading;
  final VoidCallback? onWithdraw;

  const BalanceDetails({super.key, this.info, this.loading = false, this.onWithdraw});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization.referralBalanceDetails,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242323),
            ),
          ),
          const SizedBox(height: 16),
          _BalanceRow(
            label: context.localization.referralPendingBalance,
            value: info?.pendingBalance,
            valueColor: const Color(0xFFF6A623),
            loading: loading,
          ),
          const SizedBox(height: 12),
          _BalanceRow(
            label: context.localization.referralAvailableBalance,
            value: info?.availableBalance,
            valueColor: const Color(0xFF4CAF50),
            loading: loading,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          _BalanceRow(
            label: context.localization.referralLifetimeEarned,
            value: info?.lifetimeEarned,
            valueColor: const Color(0xFF242323),
            loading: loading,
          ),
          if (!loading) ...[
            const SizedBox(height: 16),
            _WithdrawButton(
              enabled: (info?.availableBalance ?? 0) >= 50,
              onTap: onWithdraw,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                context.localization.referralMinimumWithdrawal,
                style: const TextStyle(fontSize: 12, color: Color(0xFF717171)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final String label;
  final double? value;
  final Color valueColor;
  final bool loading;

  const _BalanceRow({
    required this.label,
    this.value,
    required this.valueColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF717171),
          ),
        ),
        if (loading)
          Container(
            width: 60,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        else
          Text(
            '${(value ?? 0).toStringAsFixed(2)} ₼',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
      ],
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;

  const _WithdrawButton({required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? const Color(0xFF3696E7) : const Color(0xFFD9D9D9),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          context.localization.referralWithdraw,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: enabled ? const Color(0xFF3696E7) : const Color(0xFFB0B0B0),
          ),
        ),
      ),
    );
  }
}
