import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/common/widgets/custom_toast.dart';
import 'package:carfy/domain/entities/referral/referral_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralInfoCard extends StatelessWidget {
  final ReferralInfo? info;
  final bool loading;
  final VoidCallback? onEditCode;

  const ReferralInfoCard({super.key, this.info, this.loading = false, this.onEditCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TierBadge(
            tier: info?.tier,
            rate: info?.rate,
            loading: loading,
          ),
          const SizedBox(height: 16),
          if (loading)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (_) => Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            )
          else if (info != null)
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    value: info!.totalReferrals,
                    label: context.localization.referralTotalReferrals,
                    color: const Color(0xFF242323),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    value: info!.activeReferrals,
                    label: context.localization.referralActive,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    value: info!.pendingReferrals,
                    label: context.localization.referralPending,
                    color: const Color(0xFFF6A623),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          _CopyRow(
            label: context.localization.referralYourCode,
            value: info?.code,
            loading: loading,
            onCopy: () => _copy(context, info?.code),
            onEdit: onEditCode,
          ),
          const SizedBox(height: 12),
          _CopyRow(
            label: context.localization.referralLink,
            value: info?.link,
            loading: loading,
            onCopy: () => _copy(context, info?.link),
          ),
        ],
      ),
    );
  }

  void _copy(BuildContext context, String? value) {
    if (value == null || value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    CustomToast.showSuccess(context, context.localization.copied);
  }
}

class _TierBadge extends StatelessWidget {
  final String? tier;
  final String? rate;
  final bool loading;

  const _TierBadge({this.tier, this.rate, this.loading = false});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        width: 120,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }

    final tierName = (tier ?? '').isNotEmpty
        ? '${tier![0].toUpperCase()}${tier!.substring(1)}'
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF6A623)),
        color: const Color(0xFFFFF8E1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 16, color: Color(0xFFF6A623)),
          const SizedBox(width: 6),
          Text(
            '$tierName · $rate',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF6A623),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: Color(0xFF717171),
          ),
        ),
      ],
    );
  }
}

class _CopyRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool loading;
  final VoidCallback onCopy;
  final VoidCallback? onEdit;

  const _CopyRow({
    required this.label,
    this.value,
    this.loading = false,
    required this.onCopy,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF717171),
          ),
        ),
        if (loading)
          Container(
            width: 80,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(4),
            ),
          )
        else ...[
          Flexible(
            child: Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF242323),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onCopy,
              child: const Icon(Icons.copy_outlined, size: 16, color: Color(0xFF717171)),
            ),
          ],
          if (onEdit != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF717171)),
            ),
          ],
        ],
      ],
    );
  }
}
