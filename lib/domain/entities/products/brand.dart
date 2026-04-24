import 'package:carfy/domain/entities/products/brand_model_item.dart';

class Brand {
  final int id;
  final String? uuid;
  final String slug;
  final String title;
  final List<BrandModelItem> models;

  Brand({
    required this.id,
    this.uuid,
    required this.slug,
    required this.title,
    this.models = const [],
  });
}
