import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:flutter/material.dart';

class ProductDetailsTable extends StatelessWidget {
  final ProductShow product;

  const ProductDetailsTable({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <_DetailRow>[];

    if (product.city != null) {
      rows.add(_DetailRow(label: context.localization.city, value: product.city!.title));
    }
    for (final option in product.options) {
      rows.add(_DetailRow(label: option.option.title, value: option.item.title));
    }
    if (product.product?.brand != null) {
      rows.add(_DetailRow(label: context.localization.brand, value: product.product!.brand!.title));
    }
    if (product.year != null) {
      rows.add(_DetailRow(label: context.localization.year, value: product.year.toString()));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
      child: Column(
        children: [
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      row.label,
                      style: const TextStyle(color: Color(0xFFA2ADC8), fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      style: TextStyle(color: context.theme.colors.textDark, fontSize: 12, fontWeight: FontWeight.w300),
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

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});
}
