part of '../page/order_detail_page.dart';

class _OrderProductsSection extends StatelessWidget {
  final List<OrderItem> items;

  const _OrderProductsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.orderSuccessProducts,
          style: const TextStyle(
            color: Color(0xFF292929),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              _OrderProductItem(item: items[index]),
        ),
      ],
    );
  }
}

class _OrderProductItem extends StatelessWidget {
  final OrderItem item;

  const _OrderProductItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE7F2FC)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 111,
            height: 111,
            padding: const EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: UnconstrainedBox(
                child: item.product.hoverImage != null
                    ? CachedNetworkImage(
                        imageUrl: item.product.hoverImage!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      )
                    : Container(
                        width: 97,
                        height: 97,
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      color: Color(0xFF292929),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.product.oemCode != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.product.oemCode!,
                      style: TextStyle(
                        color: const Color(0xFF292929).withValues(alpha: 0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${item.amountFinal.toStringAsFixed(2)} \u20BC',
                    style: TextStyle(
                      color: context.theme.colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
