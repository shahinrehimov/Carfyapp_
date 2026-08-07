import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/entities/products/working_hour.dart';
import 'package:flutter/material.dart';

class SellerAvailabilitySection extends StatefulWidget {
  final ProductShow product;

  const SellerAvailabilitySection({super.key, required this.product});

  @override
  State<SellerAvailabilitySection> createState() => _SellerAvailabilitySectionState();
}

class _SellerAvailabilitySectionState extends State<SellerAvailabilitySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final seller = widget.product.seller;
    if (seller == null || seller.workingHours.isEmpty) return const SizedBox.shrink();

    final availability = seller.availability;
    final isOpen = availability?.isOpen ?? false;
    final storeLabel = seller.label ?? seller.storeCode ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.colors.border2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.storefront_outlined, size: 18, color: context.theme.colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    storeLabel,
                    style: TextStyle(
                      color: context.theme.colors.textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isOpen ? const Color(0xFF4CAF50) : const Color(0xFFF6683C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOpen ? context.localization.storeOpen : context.localization.storeClosed,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isOpen ? const Color(0xFF4CAF50) : const Color(0xFFF6683C),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.schedule_outlined, size: 16, color: context.theme.colors.textLight),
                  const SizedBox(width: 8),
                  Text(
                    context.localization.storeWorkingHours,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: context.theme.colors.textDark,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: context.theme.colors.textLight),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: seller.workingHours
                    .map((wh) => _WorkingHourRow(workingHour: wh))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WorkingHourRow extends StatelessWidget {
  final WorkingHour workingHour;

  const _WorkingHourRow({required this.workingHour});

  String _dayName(BuildContext context, int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return context.localization.weekdayMonday;
      case 2:
        return context.localization.weekdayTuesday;
      case 3:
        return context.localization.weekdayWednesday;
      case 4:
        return context.localization.weekdayThursday;
      case 5:
        return context.localization.weekdayFriday;
      case 6:
        return context.localization.weekdaySaturday;
      case 7:
        return context.localization.weekdaySunday;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayName = _dayName(context, workingHour.dayOfWeek);
    final timeText = workingHour.isClosed
        ? context.localization.closedForToday
        : (workingHour.openTime != null && workingHour.closeTime != null
            ? '${workingHour.openTime} - ${workingHour.closeTime}'
            : context.localization.closedForToday);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dayName,
            style: TextStyle(fontSize: 13, color: context.theme.colors.textDark),
          ),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 13,
              color: workingHour.isClosed ? context.theme.colors.textLight : context.theme.colors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
