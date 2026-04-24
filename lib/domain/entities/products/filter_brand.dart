import 'package:carfy/domain/entities/products/brand_model_item.dart';

class FilterBrand {
  final int id;
  final String slug;
  final String title;
  final List<BrandModelItem> models;

  FilterBrand({
    required this.id,
    required this.slug,
    required this.title,
    this.models = const [],
  });
}
