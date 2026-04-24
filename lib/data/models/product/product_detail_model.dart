import 'package:carfy/data/models/product/brand_model.dart';
import 'package:carfy/data/models/product/category_slugs_model.dart';
import 'package:carfy/data/models/product/product_category_model.dart';

class ProductDetailModel {
  final int id;
  final String uuid;
  final String slug;
  final CategorySlugsModel? categorySlugs;
  final ProductCategoryModel? mainCategory;
  final List<ProductCategoryModel> categories;
  final String title;
  final String? descriptionShort;
  final String? description;
  final String? delivery;
  final String? note;
  final String? mainImage;
  final String? hoverImage;
  final List<String> images;
  final bool isSet;
  final BrandModel? brand;

  ProductDetailModel({
    required this.id,
    required this.uuid,
    required this.slug,
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      categorySlugs: json['category_slugs'] != null
          ? CategorySlugsModel.fromJson(json['category_slugs'] as Map<String, dynamic>)
          : null,
      mainCategory: json['main_category'] != null
          ? ProductCategoryModel.fromJson(json['main_category'] as Map<String, dynamic>)
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List<dynamic>)
              .map((e) => ProductCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      title: json['title'] as String,
      descriptionShort: json['description_short'] as String?,
      description: json['description'] as String?,
      delivery: json['delivery'] as String?,
      note: json['note'] as String?,
      mainImage: json['main_image'] as String?,
      hoverImage: json['hover_image'] as String?,
      images: json['images'] != null
          ? (json['images'] as List<dynamic>).map((e) => e as String).toList()
          : [],
      isSet: json['is_set'] as bool? ?? false,
      brand: json['brand'] != null
          ? BrandModel.fromJson(json['brand'] as Map<String, dynamic>)
          : null,
    );
  }
}
