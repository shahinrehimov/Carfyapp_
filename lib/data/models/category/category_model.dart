class CategoryModel {
  final int id;
  final String uuid;
  final String slug;
  final String title;
  final String image;
  final List<SubCategoryModel> subs;

  CategoryModel({
    required this.id,
    required this.uuid,
    required this.slug,
    required this.title,
    required this.image,
    required this.subs,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      subs:
          (json['subs'] as List<dynamic>?)?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>)).toList() ??
          [],
    );
  }
}

class SubCategoryModel {
  final int id;
  final String uuid;
  final String slug;
  final String title;

  SubCategoryModel({required this.id, required this.uuid, required this.slug, required this.title});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
    );
  }
}
