import 'package:carfy/domain/entities/products/brand.dart';
import 'package:carfy/domain/entities/products/category_slugs.dart';

class ProductInfo {
  final int id;
  final String uuid;
  final CategorySlugs? categorySlugs;
  final String title;
  final String? descriptionShort;
  final String? hoverImage;
  final bool isSet;
  final Brand? brand;

  ProductInfo({
    required this.id,
    required this.uuid,
    this.categorySlugs,
    required this.title,
    this.descriptionShort,
    this.hoverImage,
    required this.isSet,
    this.brand,
  });
}
