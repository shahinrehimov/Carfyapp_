import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/referral/referral_perks.dart';
import 'package:flutter/material.dart';

class ReferralPerksCard extends StatelessWidget {
  final ReferralPerks perks;

  const ReferralPerksCard({super.key, required this.perks});

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
            context.localization.referralPerks,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF242323),
            ),
          ),
          const SizedBox(height: 16),
          _PerkItem(
            icon: Icons.local_shipping_outlined,
            color: const Color(0xFF4CAF50),
            text:
                '${context.localization.referralFreeDelivery} (${perks.freeDeliveryRemaining})',
          ),
          const SizedBox(height: 12),
          _PerkItem(
            icon: Icons.discount_outlined,
            color: const Color(0xFF3696E7),
            text:
                '${perks.discountRate} ${context.localization.referralDiscount} (${perks.discountOrdersRemaining})',
          ),
        ],
      ),
    );
  }
}

class _PerkItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _PerkItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF242323),
          ),
        ),
      ],
    );
  }
}
