part of '../page/order_detail_page.dart';

class _OrderInfoCard extends StatelessWidget {
  final OrderDetail order;

  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            label: context.localization.orderDetailOrder,
            child: Row(
              children: [
                Text(
                  'ID: ${order.code}',
                  style: const TextStyle(
                    color: Color(0xFF292929),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order.code));
                    CustomToast.showSuccess(context, context.localization.copied);
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    size: 15,
                    color: context.theme.colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: context.localization.orderDetailDelivery,
            child: Text(
              order.date,
              style: const TextStyle(
                color: Color(0xFF292929),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            label: context.localization.amount,
            child: Text(
              '${order.amountFinal.toStringAsFixed(2)}\u20BC',
              style: const TextStyle(
                color: Color(0xFF292929),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _InfoRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF292929),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }
}
