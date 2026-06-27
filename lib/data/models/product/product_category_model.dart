class ProductCategoryModel {
  final int id;
  final String uuid;
  final String slug;
  final String title;
  final ProductCategoryModel? parent;

  ProductCategoryModel({required this.id, required this.uuid, required this.slug, required this.title, this.parent});

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      parent: json['parent'] != null ? ProductCategoryModel.fromJson(json['parent'] as Map<String, dynamic>) : null,
    );
  }
}
