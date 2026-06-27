import 'package:carfy/data/models/product/brand_model_item_model.dart';

class BrandModel {
  final int id;
  final String? uuid;
  final String slug;
  final String title;
  final List<BrandModelItemModel> models;

  BrandModel({required this.id, this.uuid, required this.slug, required this.title, this.models = const []});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String?,
      slug: json['slug'] as String,
      title: json['title'] as String,
      models: (json['brand_models'] ?? json['models']) != null
          ? ((json['brand_models'] ?? json['models']) as List<dynamic>)
                .map((item) => BrandModelItemModel.fromJson(item as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
