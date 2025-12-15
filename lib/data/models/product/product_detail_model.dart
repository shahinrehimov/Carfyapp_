import 'package:carfy/data/models/product/brand_model.dart';
import 'package:carfy/data/models/product/category_slugs_model.dart';

class ProductDetailModel {
  final int id;
  final String uuid;
  final String slug;
  final CategorySlugsModel? categorySlugs;
  final String title;
  final String? descriptionShort;
  final String? hoverImage;
  final bool isSet;
  final BrandModel? brand;

  ProductDetailModel({
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      categorySlugs: json['category_slugs'] != null
          ? CategorySlugsModel.fromJson(json['category_slugs'] as Map<String, dynamic>)
          : null,
      title: json['title'] as String,
      descriptionShort: json['description_short'] as String?,
      hoverImage: json['hover_image'] as String?,
      isSet: json['is_set'] as bool,
      brand: json['brand'] != null
          ? BrandModel.fromJson(json['brand'] as Map<String, dynamic>)
          : null,
    );
  }
}
