part of '../page/order_detail_page.dart';

class _OrderAddressSection extends StatelessWidget {
  final OrderAddress address;

  const _OrderAddressSection({required this.address});

  @override
  Widget build(BuildContext context) {
    final addressText = [
      '${address.city.title},',
      address.addressLine1,
      if (address.addressLine2 != null && address.addressLine2!.isNotEmpty) address.addressLine2,
    ].join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.orderSuccessDeliveryAddress,
          style: const TextStyle(color: Color(0xFF292929), fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            addressText,
            style: const TextStyle(
              color: Color(0xFF292929),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.6,
              letterSpacing: 0.36,
            ),
          ),
        ),
      ],
    );
  }
}
