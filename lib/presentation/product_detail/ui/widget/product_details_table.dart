import 'package:carfy/common/theme/theme.dart';
import 'package:carfy/common/translations/translation_context_extension.dart';
import 'package:carfy/domain/entities/products/fitment.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:flutter/material.dart';

class ProductDetailsTable extends StatelessWidget {
  final ProductShow product;

  const ProductDetailsTable({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <_DetailRow>[];

    if (product.seller?.city != null) {
      rows.add(_DetailRow(label: context.localization.city, value: product.seller!.city!.title));
    }
    if (product.product?.mainCategory != null) {
      rows.add(_DetailRow(label: context.localization.category, value: product.product!.mainCategory!.title));
    }

    if (product.fitments.isNotEmpty) {
      _buildFitmentRows(context, product.fitments, rows);
    } else {
      // No fitments — fall back to product-level fields
      if (product.product?.brand != null) {
        rows.add(_DetailRow(label: context.localization.brand, value: product.product!.brand!.title));
      }
      if (product.isUniversal) {
        rows.add(_DetailRow(
          label: context.localization.compatibleVehicles,
          value: context.localization.universalProduct,
        ));
      } else {
        final yearValue = _formatYearRange(product.yearFrom, product.yearTo) ??
            (product.year != null ? product.year.toString() : null);
        if (yearValue != null) {
          rows.add(_DetailRow(label: context.localization.year, value: yearValue));
        }
      }
    }

    for (final option in product.options) {
      rows.add(_DetailRow(label: option.label, value: option.value));
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
                      style: TextStyle(
                        color: context.theme.colors.textDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
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

  void _buildFitmentRows(BuildContext context, List<Fitment> fitments, List<_DetailRow> rows) {
    final brandNames = fitments.map((f) => f.brand?.title).toSet();
    final singleBrand = brandNames.length == 1 && brandNames.first != null;
    final allYearsSame = _allYearsSame(fitments);

    if (singleBrand) {
      rows.add(_DetailRow(label: context.localization.brand, value: brandNames.first!));

      if (allYearsSame) {
        // All models share the same year range — join models on one row
        final modelNames = fitments.map((f) => f.brandModel?.title).whereType<String>().join(', ');
        if (modelNames.isNotEmpty) {
          rows.add(_DetailRow(label: context.localization.vehicleModels, value: modelNames));
        }
        final yearValue = _formatYearRange(fitments.first.yearFrom, fitments.first.yearTo);
        if (yearValue != null) {
          rows.add(_DetailRow(label: context.localization.year, value: yearValue));
        }
      } else {
        // Different years — each model gets its own row with year appended
        for (final fitment in fitments) {
          final model = fitment.brandModel?.title;
          if (model == null || model.isEmpty) continue;
          final yearValue = _formatYearRange(fitment.yearFrom, fitment.yearTo);
          final value = yearValue != null ? '$model $yearValue' : model;
          rows.add(_DetailRow(label: context.localization.vehicleModel, value: value));
        }
      }
    } else {
      // Multiple brands
      if (allYearsSame) {
        // No year per row — show once at the end
        for (final fitment in fitments) {
          final brand = fitment.brand?.title ?? '';
          final model = fitment.brandModel?.title ?? '';
          final value = [brand, model].where((s) => s.isNotEmpty).join(' ');
          if (value.isNotEmpty) {
            rows.add(_DetailRow(label: context.localization.compatibleVehicles, value: value));
          }
        }
        final yearValue = _formatYearRange(fitments.first.yearFrom, fitments.first.yearTo);
        if (yearValue != null) {
          rows.add(_DetailRow(label: context.localization.year, value: yearValue));
        }
      } else {
        // Different years — append year range to each row
        for (final fitment in fitments) {
          final brand = fitment.brand?.title ?? '';
          final model = fitment.brandModel?.title ?? '';
          final parts = [brand, model].where((s) => s.isNotEmpty).join(' ');
          if (parts.isEmpty) continue;
          final yearValue = _formatYearRange(fitment.yearFrom, fitment.yearTo);
          final value = yearValue != null ? '$parts $yearValue' : parts;
          rows.add(_DetailRow(label: context.localization.compatibleVehicles, value: value));
        }
      }
    }
  }

  static bool _allYearsSame(List<Fitment> fitments) {
    if (fitments.isEmpty) return true;
    final first = fitments.first;
    return fitments.every((f) => f.yearFrom == first.yearFrom && f.yearTo == first.yearTo);
  }

  static String? _formatYearRange(int? yearFrom, int? yearTo) {
    if (yearFrom == null && yearTo == null) return null;
    if (yearFrom != null && yearTo != null) {
      if (yearFrom == yearTo) return yearFrom.toString();
      return '$yearFrom–$yearTo';
    }
    if (yearFrom != null) return '$yearFrom+';
    return '–$yearTo';
  }
}

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});
}
