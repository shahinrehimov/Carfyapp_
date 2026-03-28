import 'package:carfy/data/models/product/product_model.dart';

class GroupModel {
  final String name;
  final String slug;
  final String title;
  final String? description;
  final String? image;
  final List<ProductModel> products;

  GroupModel({
    required this.name,
    required this.slug,
    required this.title,
    this.description,
    this.image,
    required this.products,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      products: json['product_variants'] != null
          ? (json['product_variants'] as List<dynamic>)
              .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
