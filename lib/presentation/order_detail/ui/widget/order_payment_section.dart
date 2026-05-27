part of '../page/order_detail_page.dart';

class _OrderPaymentSection extends StatelessWidget {
  final OrderPaymentMethod paymentMethod;

  const _OrderPaymentSection({required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.paymentTitle,
          style: const TextStyle(
            color: Color(0xFF292929),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod.label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: 0.36,
                ),
              ),
              const SizedBox(height: 8),
              _PaymentStatusBadge(
                status: paymentMethod.paymentStatus,
                label: paymentMethod.paymentStatusLabel,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const _PaymentStatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = switch (status) {
      'paid' || 'completed' => (const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
      'pending' => (const Color(0xFFFFF3E0), const Color(0xFFFF9800)),
      'failed' => (const Color(0xFFFFEBEE), const Color(0xFFF44336)),
      _ => (const Color(0xFFF5F5F5), const Color(0xFF757575)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
