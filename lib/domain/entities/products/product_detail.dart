import 'package:carfy/domain/entities/products/brand.dart';
import 'package:carfy/domain/entities/products/category_slugs.dart';
import 'package:carfy/domain/entities/products/product_category.dart';

class ProductDetail {
  final int id;
  final String uuid;
  final CategorySlugs? categorySlugs;
  final ProductCategory? mainCategory;
  final List<ProductCategory> categories;
  final String title;
  final String? descriptionShort;
  final String? description;
  final String? delivery;
  final String? note;
  final String? mainImage;
  final String? hoverImage;
  final List<String> images;
  final bool isSet;
  final Brand? brand;

  ProductDetail({
    required this.id,
    required this.uuid,
    this.categorySlugs,
    this.mainCategory,
    this.categories = const [],
    required this.title,
    this.descriptionShort,
    this.description,
    this.delivery,
    this.note,
    this.mainImage,
    this.hoverImage,
    this.images = const [],
    required this.isSet,
    this.brand,
  });
}
