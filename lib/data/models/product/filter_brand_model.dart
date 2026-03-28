import 'package:carfy/data/models/product/brand_model_item_model.dart';

class FilterBrandModel {
  final int id;
  final String slug;
  final String title;
  final List<BrandModelItemModel> models;

  FilterBrandModel({required this.id, required this.slug, required this.title, this.models = const []});

  factory FilterBrandModel.fromJson(Map<String, dynamic> json) {
    return FilterBrandModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      models: json['brand_models'] != null
          ? (json['brand_models'] as List).map((e) => BrandModelItemModel.fromJson(e)).toList()
          : [],
    );
  }
}
