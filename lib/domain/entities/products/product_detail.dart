import 'package:carfy/domain/entities/products/brand.dart';
import 'package:carfy/domain/entities/products/category_slugs.dart';

class ProductDetail {
  final int id;
  final String uuid;
  final String slug;
  final CategorySlugs? categorySlugs;
  final String title;
  final String? descriptionShort;
  final String? hoverImage;
  final bool isSet;
  final Brand? brand;

  ProductDetail({
    required this.id,
    required this.uuid,
    required this.slug,
    this.categorySlugs,
    required this.title,
    this.descriptionShort,
    this.hoverImage,
    required this.isSet,
    this.brand,
  });
}
