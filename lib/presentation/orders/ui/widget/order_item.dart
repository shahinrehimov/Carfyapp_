part of '../page/orders_page.dart';

class _OrderItem extends StatelessWidget {
  final OrderSummary order;

  const _OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: context.theme.colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.code,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.theme.colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.localization.orderSuccessProducts} (${order.productsCount})',
                  style: TextStyle(fontSize: 12, color: context.theme.colors.black.withValues(alpha: 0.5)),
                ),
                const SizedBox(height: 4),
                Text(
                  order.date,
                  style: TextStyle(fontSize: 12, color: context.theme.colors.black.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
          _StatusBadge(status: order.status, label: order.statusLabel),
          const SizedBox(width: 12),
          Icon(Icons.chevron_right_rounded, color: context.theme.colors.black.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const _StatusBadge({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor) = _getStatusColors(status, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }

  (Color, Color) _getStatusColors(String status, BuildContext context) {
    return switch (status) {
      'pending' || 'payment_pending' => (const Color(0xFFFFF3E0), const Color(0xFFFF9800)),
      'processing' || 'confirmed' => (const Color(0xFFE3F2FD), const Color(0xFF2196F3)),
      'shipped' || 'courier_assigned' => (const Color(0xFFE8EAF6), const Color(0xFF3F51B5)),
      'delivered' => (const Color(0xFFE8F5E9), const Color(0xFF4CAF50)),
      'canceled' || 'failed' => (const Color(0xFFFFEBEE), const Color(0xFFF44336)),
      'returned' => (const Color(0xFFFCE4EC), const Color(0xFFE91E63)),
      _ => (const Color(0xFFF5F5F5), const Color(0xFF757575)),
    };
  }
}
